extends Node

enum ReadPermissions { NO_READ, OWNER_READ, PUBLIC_READ }
enum WritePermissions {NO_WRITE, OWNER_WRITE}

const KEY := "defaultkey"

var _session : NakamaSession
var _client := Nakama.create_client(KEY, "31.207.39.111", 7350, "http")

var _socket : NakamaSocket
var _match_id : String
var _matchmaker_ticket : String

# ----------------------------
# CONNECT AND AUTENTICATION
# ----------------------------
func authenticate_async() -> String:
	var new_session: NakamaSession = await _client.authenticate_device_async(UserData.get_device_id())
	if new_session.is_exception():
		Console.log("An error occurred: %s" % new_session.get_exception().status_code, Console.LogLevel.ERROR)
		return "ERROR"
	else:
		_session = new_session
		Console.log("Server connection established.")
		
		if _session.created :
			return "NEW_SESSION"
		else :
			return "OK"

func authenticate_admin_async(username: String, password: String) -> String:
	print("admin_connect")
	var email := username + "@gamoap.com"
	var admin_session = await _client.authenticate_email_async(email, password, username, false)
	if admin_session.is_exception():
		Console.log("An error occurred: %s" % admin_session.get_exception().status_code, Console.LogLevel.ERROR)
		return "ERROR"
	else:
		_session = admin_session
		Console.log("Server connection established as admin.")
		return "OK"

func connect_to_server_async() -> int:
	_socket = Nakama.create_socket_from(_client)
	var result: NakamaAsyncResult = await _socket.connect_async(_session)
	if not result.is_exception():
		_socket.connected.connect(_on_Socket_connected)
		_socket.closed.connect(_on_Socket_closed)
		_socket.received_error.connect(_on_Socket_received_error)
		
		_socket.received_matchmaker_matched.connect(_on_matchmaker_matched)
		_socket.received_match_state.connect(_on_match_state)
		
		return OK
	return ERR_CANT_CONNECT

func _on_Socket_connected() -> void:
	Console.log("Socket connected.")

func _on_Socket_closed(code: int, reason: String) -> void:
	Console.log("Socket closed. Code : %s | Raison : %s" % [code, reason],Console.LogLevel.WARNING)
	_match_id = ""
	_matchmaker_ticket = ""
	_socket = null

func _on_Socket_received_error() -> void:
	Console.log("Socket received_error.",Console.LogLevel.ERROR)

# ----------------------------
# MATCH MAKING
# ----------------------------
func start_matchmaking():
	# Matchmaking criteria
	var query = "*"
	var min_players = 2
	var max_players = 2
	
	var matchmaking_ticket_obj : NakamaRTAPI.MatchmakerTicket = await _socket.add_matchmaker_async(
		query,
		min_players,
		max_players
	)
	if matchmaking_ticket_obj.is_exception() :
		Console.log("Erreur matchmaking : %s" % matchmaking_ticket_obj.exception,Console.LogLevel.ERROR)
	else :
		_matchmaker_ticket = matchmaking_ticket_obj.ticket
		Console.log("waiting for the opponent... match : %s" % _matchmaker_ticket)

func _on_matchmaker_matched(matched: NakamaRTAPI.MatchmakerMatched) -> void:
	Console.log("Match found !")
	
	var match: NakamaRTAPI.Match = await _socket.join_matched_async(matched)
	_match_id = match.match_id
	var match_data := {}
	
	for matched_user in matched.users :
		var userdata = matched_user.presence
		if userdata.user_id != _session.user_id:
			match_data = {
				"opponent_data": {
					"user_id": userdata.user_id,
					"username": userdata.username
				}
			}
			Console.log("Opponent id : %s" % match_data["opponent_data"]["user_id"])
	
	EventManager.emit_match_found(match_data)

# ----------------------------
# SEND/RECEIVED DATA
# ----------------------------
func send_turn(turn_data: Dictionary) -> void:
	if not _match_id:
		Console.log("No active match.", Console.LogLevel.ERROR)
		return
		
	var op_code: int = 1
	await _socket.send_match_state_async(_match_id, op_code, JSON.stringify(turn_data))

func _on_match_state(match_state : NakamaRTAPI.MatchData) -> void:
	if match_state.op_code == 1:
		var turn_data = JSON.parse_string(match_state.data)
		EventManager.emit_turn_received(turn_data)

# ----------------------------
# LEAVE MATCH
# ----------------------------
func leave_match() -> void:
	if _socket and _match_id:
		await _socket.leave_match_async(_match_id)
	if _socket:
		await _socket.close_async()

# ----------------------------
# USER ACCOUNT
# ----------------------------
func get_user_account_async() -> Dictionary:
	var account = await _client.get_account_async(_session)
	if account.is_exception():
		Console.log("Account recovery error: %s" % account)
		return {}
	else:
		var user = account.user
		var user_info = {
			"user_id": user.id,
			"username": user.username,
		}
		return user_info

func update_user_account_async(
	username: String = ""
) -> void:
	var update_result = await _client.update_account_async(
		_session,
		username
	)
	if update_result.is_exception():
		Console.log("Error updating account : %s" % update_result)

# ----------------------------
# USER STORAGE
# ----------------------------
func write_data(collection: String, key: String, value: Dictionary, read_permision := ReadPermissions.OWNER_READ ) -> void:
	var result: NakamaAsyncResult = await _client.write_storage_objects_async(_session,
	[
		NakamaWriteStorageObject.new(
			collection,
			key,
			read_permision,
			WritePermissions.OWNER_WRITE,
			JSON.stringify({data = value}),
			""
		)
	])
	if result.is_exception():
		Console.log("Write player data error : %" % result, Console.LogLevel.ERROR)

func load_data(collection: String, key: String, user_id:= _session.user_id) -> Dictionary:
	var storage_objects: NakamaAPI.ApiStorageObjects = await  _client.read_storage_objects_async(
		_session,[NakamaStorageObjectId.new(
			collection,
			key,
			user_id
			)]
	)
	if storage_objects.objects:
		var decoded :Dictionary = JSON.parse_string(storage_objects.objects[0].value).data
		return decoded
	return {}

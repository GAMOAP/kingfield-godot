extends Node


const KEY := "defaultkey"

var _device_id = OS.get_unique_id()
var args = OS.get_cmdline_args()

var _session : NakamaSession
var _client := Nakama.create_client(KEY, "31.207.39.111", 7350, "http")

var _socket : NakamaSocket
var _match_id : String
var _matchmaker_ticket : String

var opponent_data : Dictionary = {}

signal match_found()
signal turn_received(turn_data: Dictionary)

# ----------------------------
# CONNECT AND AUTENTICATION
# ----------------------------
func authenticate_async() -> String:
	# set gotot instance device ID
	for arg in args:
		_device_id = arg.replace("--device_id=", "")
	
	var new_session: NakamaSession = await _client.authenticate_device_async(_device_id)
	if new_session.is_exception():
		DebugConsole.log("An error occurred: %s" % new_session.get_exception().status_code, DebugConsole.LogLevel.ERROR)
		return "ERROR"
	else:
		_session = new_session
		DebugConsole.log("Server connection established.")
		
		if _session.created :
			return "NEW_SESSION"
		else :
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
	DebugConsole.log("Socket connected.")

func _on_Socket_closed(code: int, reason: String) -> void:
	DebugConsole.log("Socket closed. Code : %s | Raison : %s" % [code, reason],DebugConsole.LogLevel.WARNING)
	_match_id = ""
	_matchmaker_ticket = ""
	_socket = null

func _on_Socket_received_error() -> void:
	DebugConsole.log("Socket received_error.",DebugConsole.LogLevel.ERROR)

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
		DebugConsole.log("Erreur matchmaking : %s" % matchmaking_ticket_obj.exception,DebugConsole.LogLevel.ERROR)
	else :
		_matchmaker_ticket = matchmaking_ticket_obj.ticket
		DebugConsole.log("waiting for the opponent... match : %s" % _matchmaker_ticket)

func _on_matchmaker_matched(matched: NakamaRTAPI.MatchmakerMatched) -> void:
	DebugConsole.log("Match found !")
	
	var match: NakamaRTAPI.Match = await _socket.join_matched_async(matched)
	_match_id = match.match_id
	
	for matched_user in matched.users :
		var userdata = matched_user.presence
		if userdata.user_id != _session.user_id:
			opponent_data = {
				"user_id": userdata.user_id,
				"username": userdata.username
			}
			DebugConsole.log("Opponent id : %s" % opponent_data.get("user_id"))
	
	match_found.emit()

# ----------------------------
# SEND/RECEIVED DATA
# ----------------------------
func send_turn(turn_data: Dictionary) -> void:
	if not _match_id:
		DebugConsole.log("No active match.", DebugConsole.LogLevel.ERROR)
		return
		
	var op_code: int = 1
	await _socket.send_match_state_async(_match_id, op_code, JSON.stringify(turn_data))

func _on_match_state(match_state : NakamaRTAPI.MatchData) -> void:
	print("MATCH_STATE_RECEIVED")
	
	if match_state.op_code == 1:
		var turn_data = JSON.parse_string(match_state.data)
		turn_received.emit(turn_data)

# ----------------------------
# USER ACCOUNT
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
		DebugConsole.log("Account recovery error: %s" % account)
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
		DebugConsole.log("Error updating account : %s" % update_result)

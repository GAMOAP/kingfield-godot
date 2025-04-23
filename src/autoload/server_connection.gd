extends Node


const KEY := "defaultkey"

var _device_id = OS.get_unique_id()

var _session : NakamaSession
var _client := Nakama.create_client(KEY, "31.207.39.111", 7350, "http")

var _socket : NakamaSocket


func authenticate_async() -> int:
	var new_session: NakamaSession = await _client.authenticate_device_async(_device_id)
	if new_session.is_exception():
		DebugConsole.log("An error occurred: %s" % _session, DebugConsole.LogLevel.ERROR)
		return new_session.get_exception().status_code
	else:
		DebugConsole.log("Successfully authenticated: %s" % _session)
		_session = new_session
		return OK

func connect_to_server_async() -> int:
	_socket = Nakama.create_socket_from(_client)
	var result: NakamaAsyncResult = await  _socket.connect_async(_session)
	if not result.is_exception():
		_socket.connected.connect(_on_Socket_connected)
		_socket.closed.connect(_on_Socket_closed)
		_socket.received_error.connect(_on_Socket_received_error)
		
		_socket.received_match_presence.connect(_on_match_presence)
		_socket.received_match_state.connect(_on_match_state)
		
		return OK
	return ERR_CANT_CONNECT

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

func join_world_async() -> Dictionary:
	var world: NakamaAPI.ApiRpc = await _client.rpc_async(_session,"get_world_id", "")
	return {}
	

func _on_Socket_connected() -> void:
	pass

func _on_Socket_closed() -> void:
	_socket = null

func _on_Socket_received_error() -> void:
	pass

func _on_match_presence(presence : NakamaRTAPI.MatchPresenceEvent):
	print(presence)

func _on_match_state(state : NakamaRTAPI.MatchData):
	print("data is : " + str(state.data))

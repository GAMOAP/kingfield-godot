extends Node


const KEY := "defaultkey"

var _device_id = OS.get_unique_id()

var _session : NakamaSession
var _client := Nakama.create_client(KEY, "31.207.39.111", 7350, "http")

var _socket : NakamaSocket


func authenticate_async() -> int:
	var result := OK
	var new_session: NakamaSession = await _client.authenticate_device_async(_device_id)
	if not new_session.is_exception():
		_session = new_session
	else:
		result = new_session.get_exception().status_code
	return result
	
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

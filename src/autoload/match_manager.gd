extends Node

var current_match: KF_MatchData = null


func enter_lobby() -> void:
	await ServerManager.connect_to_server_async()
	await ServerManager.start_matchmaking()
	
	EventManager.match_found.connect(_on_match_found)
	
	EventManager.player_joined.connect(_on_player_joined)
	EventManager.player_left.connect(_on_player_left)
	
	EventManager.game_start.connect(_on_game_start)
	EventManager.turn_processed.connect(_on_processed_turn)
	EventManager.turn_error.connect(_on_error_turn)

func _on_match_found(match_data) -> void:
	var match_id = match_data["match_id"]
	
	var self_data = {
		"username" : DataManager.user_info["username"],
		"user_id" : DataManager.user_info["user_id"],
	}
	var opponent_data = {
		"username" : match_data["opponent_data"]["username"],
		"user_id" :  match_data["opponent_data"]["user_id"],
	}
	
	create_match(match_id, self_data, opponent_data)
	EventManager.player_left.connect(_on_player_left)

func create_match(match_id: String, self_data: Dictionary, opponent_data: Dictionary):
	current_match = KF_MatchData.new()
	current_match.setup(match_id, self_data, opponent_data)

func _on_game_start(game_data):
	var board_players = game_data["units_state"]["units"]
	var match_players = current_match.players
	var current_player_id = game_data["current_player"]
	
	current_match.current_player_id = current_player_id
	
	#checks that the player card matches
	var self_team = await DataManager.get_user_team()
	var self_id = DataManager.user_info["user_id"]
	for unit in Global.TEAM:
		var unit_cards = self_team[unit]["cards"]
		for card_type in unit_cards:
			if unit_cards[card_type] != board_players[self_id][unit]["cards"][card_type]:
				Console.log("Match cards do not match",Console.LogLevel.ERROR)
				end_match()
	
	#init karma and player side of the board
	if self_id != current_player_id:
		match_players["opponent"]["karma"] = game_data["karma_value"][0]
		match_players["opponent"]["camp"] = Global.CAMP.WHITE
		match_players["self"]["camp"] = Global.CAMP.BLACK
	else :
		match_players["opponent"]["karma"] = game_data["karma_value"][1]
		match_players["opponent"]["camp"] = Global.CAMP.BLACK
		match_players["self"]["camp"] = Global.CAMP.WHITE
	
	#init curent match players_data
	for board_player in board_players:
		for match_player in match_players:
			if board_player == match_players[match_player]["user_id"]:
				match_players[match_player]["data"] = board_players[board_player]
	
	#current_match.set_team
	
	EventManager.emit_set_scene(Global.SCENES.MATCH)

func send_turn(actions) -> void:
	if current_match.current_player_id != DataManager.user_info["user_id"]:
		GameManager.resolve_action(false)
	
	var result = await ServerManager.send_turn({
		"turn" : current_match.turn,
		"type" : "action",
		"actions" : actions
	})

func _on_processed_turn(data) -> void:
	var actions = data["actions"]
	current_match.turn = data["turn"]
	GameManager.resolve_action(true, actions)

func _on_error_turn(data) -> void:
	GameManager.resolve_action(false)

func end_match():
	if current_match:
		current_match.reset()
	current_match = null
	
	await ServerManager.leave_match()
	EventManager.match_found.disconnect(_on_match_found)
	EventManager.game_start.disconnect(_on_game_start)
	
	GameManager.end_game()
	
	EventManager.emit_set_scene(Global.SCENES.HOME)

func _on_player_joined(player_data: Dictionary) -> void:
	print("Player_join")
	pass

func _on_player_left(player_data: Dictionary) -> void:
	end_match()
	EventManager.player_left.disconnect(_on_player_left)

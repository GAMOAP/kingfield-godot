extends Node

var current_match: KF_MatchData = null


func enter_lobby() -> void:
	await ServerManager.connect_to_server_async()
	await ServerManager.start_matchmaking()
	
	EventManager.match_found.connect(_on_match_found)
	EventManager.game_start.connect(_on_game_start)
	EventManager.player_joined.connect(_on_player_joined)
	EventManager.player_left.connect(_on_player_left)

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
	
	#checks that the player card matches
	var self_team = await DataManager.get_user_team()
	var self_id = DataManager.user_info["user_id"]
	for char in Global.TEAM:
		var char_cards = self_team[char]["cards"]
		for card_type in char_cards:
			if char_cards[card_type] != board_players[self_id][char]["cards"][card_type]:
				Console.log("Match cards do not match",Console.LogLevel.ERROR)
				end_match()
	
	#verfifier que les joueurs sont a la bonne place.
	
	#init karma and direction of the board
	var is_self_team_bottom = true
	if self_id != game_data["current_player"]:
		is_self_team_bottom = false
		match_players["opponent"]["karma"] = game_data["karma_value"][0]
	else :
		match_players["opponent"]["karma"] = game_data["karma_value"][1]
	
	match_players["self"]["is_bottom"] = is_self_team_bottom
	
	#init curent match players_data
	for board_player in board_players:
		for match_player in match_players:
			if board_player == match_players[match_player]["user_id"]:
				match_players[match_player]["data"] = board_players[board_player]
	
	#current_match.set_team
	
	EventManager.emit_set_scene(Global.SCENES.MATCH)

func end_match():
	if current_match:
		current_match.reset()
	current_match = null
	
	await ServerManager.leave_match()
	EventManager.match_found.disconnect(_on_match_found)
	EventManager.game_start.disconnect(_on_game_start)
	EventManager.emit_set_scene(Global.SCENES.HOME)

func _on_player_joined(player_data: Dictionary) -> void:
	pass

func _on_player_left(player_data: Dictionary) -> void:
	end_match()
	EventManager.player_left.disconnect(_on_player_left)

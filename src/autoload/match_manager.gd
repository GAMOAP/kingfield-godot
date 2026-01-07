extends Node

var current_match: KF_MatchData = null



func enter_lobby() -> void:
	await ServerManager.connect_to_server_async()
	await ServerManager.start_matchmaking()
	
	EventManager.match_found.connect(_on_match_found)

func _on_match_found(match_data) -> void:
	var match_id = match_data["match_id"]
	var self_data = {
		"username" : DataManager.user_info["username"],
		"user_id" : DataManager.user_info["user_id"],
		"team_data" : await DataManager.get_user_team()
	}
	var opponent_data = {
		"username" : match_data["opponent_data"]["username"],
		"user_id" :  match_data["opponent_data"]["user_id"],
		"team_data" : await ServerManager.load_data("player_data", "team", match_data["opponent_data"]["user_id"])
	}
	start_match(match_id, self_data, opponent_data)

func start_match(match_id: String, self_data: Dictionary, opponent_data: Dictionary):
	current_match = KF_MatchData.new()
	current_match.setup(match_id, self_data, opponent_data)
	
	EventManager.emit_set_scene(Global.SCENES.MATCH)

func end_match():
	if current_match:
		current_match.reset()
	current_match = null
	ServerManager.leave_match()
	EventManager.match_found.disconnect(_on_match_found)

extends Resource
class_name KF_MatchData

var match_id: String = ""
var players: Dictionary = {}  # exemple : {"self": {}, "opponent": {}}
var turn: int = 0
var state: String = "waiting"  # ou "active", "finished"

func setup(_match_id: String, _self_data: Dictionary, _opponent_data: Dictionary):
	match_id = _match_id
	players = {
		"self": _self_data,
		"opponent": _opponent_data
	}
	turn = 1
	state = "active"

func reset():
	match_id = ""
	players.clear()
	turn = 0
	state = "waiting"

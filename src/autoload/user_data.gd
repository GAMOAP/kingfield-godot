extends Node

var _device_id : String
var _args = OS.get_cmdline_args()

var _team: Dictionary = {}


func _ready() -> void:
	set_device_id()

# ----------------------------
# DEVICE ID
# ----------------------------
func get_device_id() -> String:
	return _device_id

func set_device_id() ->void:
	_device_id = OS.get_unique_id()
	# set gotot instance device_id to test
	for arg in _args:
		_device_id = arg.replace("--device_id=", "")

# ----------------------------
# USER TEAM
# ----------------------------
func get_user_team() -> Dictionary:
	_team = await ServerManagement.load_player_data("team")
	if _team == {} :
		for char in Global.TEAM:
			var char_stuff : Dictionary
			for card in Global.CARDS :
				var sign : int = randi() % Global.BREEDS.size()
				var ascending : int = 0 #randi() % Global.BREEDS.size()
				var card_type : Dictionary = {
					"sign" : sign,
					"ascending" : ascending
				}
				char_stuff[card] = card_type
			_team[char] = char_stuff
		set_user_team()
	
	return _team

func set_user_team(char: String = "", card: String = "", sign: Global.BREEDS = 0, ascending: Global.BREEDS = 0) -> void:
	if char != "" && card != "":
		_team[char][card]["sign"] = sign
		_team[char][card]["ascending"] = ascending
	ServerManagement.write_player_data("team", _team)
	

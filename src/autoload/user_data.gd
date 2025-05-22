extends Node

var _device_id : String
var _args = OS.get_cmdline_args()

var _team: Dictionary = {}
var _used_cards: Array = []

var _card_index: Dictionary = {}


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
				var is_card_used:= true
				var card_type:= {}
				while is_card_used == true:
					var sign: int = randi() % Global.BREEDS.size()
					var ascending: int = 0 #randi() % Global.BREEDS.size()
					card_type = {
						"type" : card,
						"sign" : sign,
						"ascending" : ascending
					}
					var is_used = false
					for card_tested in _used_cards:
						if card_tested["type"] == card && card_tested["sign"] == sign && card_tested["ascending"] == ascending:
							is_used = true
					is_card_used = is_used
				_used_cards.append(card_type)
				char_stuff[card] = card_type
			_team[char] = char_stuff
		set_user_team()
	
	return _team

func set_user_team(char: String = "", card: String = "", sign: Global.BREEDS = 0, ascending: Global.BREEDS = 0) -> void:
	if char != "" && card != "":
		_team[char][card]["sign"] = sign
		_team[char][card]["ascending"] = ascending
	ServerManagement.write_player_data("team", _team, ServerManagement.ReadPermissions.PUBLIC_READ)

func get_cards_index() -> Dictionary:
	_team = await ServerManagement.load_admin_data("card_index")
	return _card_index

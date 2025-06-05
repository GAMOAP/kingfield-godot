extends Node

var _device_id : String
var _args = OS.get_cmdline_args()

var _team: Dictionary
var _used_cards: Array = []

var _card_index: Dictionary = {}

var is_admin := false

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
	if not _team:
		_team = await ServerManagement.load_data("player_data", "team")
	if _team == {} :
		for char in Global.TEAM:
			var char_stuff : Dictionary
			for type in Global.CARD_TYPE.size():
				var is_card_used:= true
				var card_id := ""
				while is_card_used == true:
					var sign: int = randi() % Global.BREEDS.size()
					var ascending: int = 0 #randi() % Global.BREEDS.size()
					card_id = str(type) + str(sign) + str(ascending)
					var is_used = false
					for card_id_tested in _used_cards:
						if card_id_tested == card_id:
							is_used = true
					is_card_used = is_used
				_used_cards.append(card_id)
				char_stuff[type] = card_id
			_team[char] = char_stuff
		set_user_team()
	
	return _team

func set_user_team(char := "", card_id := "") -> void:
	if char != "" && card_id != "":
		var card = card_id.to_int() / 100
		_team[char][card] = card_id
	ServerManagement.write_data("player_data", "team", _team, ServerManagement.ReadPermissions.PUBLIC_READ)

# ----------------------------
#  ADMIN CARDS INDEX
# ----------------------------
func get_card_data(card_id) -> Dictionary:
	if not _card_index:
		#_card_index = await ServerManagement.load_data("global_data", "cards", Global.ADMIN_ID)
		if _card_index == {}:
			_card_index = _create_card_index()
	return _card_index[card_id]

func get_card_identity(card_id) -> Dictionary:
	var int_id = card_id.to_int()
	var type = int_id / 100
	var sign = (int_id - type * 100) / 10
	var ascending = int_id - (type + sign)
	return {
		"type" : type,
		"sign" : sign,
		"ascending" : ascending,
	}

func set_cards_index(card_id, data := {}) -> void :
	_card_index[card_id]["data"] = data
	ServerManagement.write_data("global_data", "cards", _card_index, ServerManagement.ReadPermissions.PUBLIC_READ)

func _create_card_index() -> Dictionary:
	var index := {}
	for type in Global.CARDS.size():
		for sign in Global.BREEDS.size():
			for ascending in Global.BREEDS.size():
				var id = str(type) + str(sign) + str(ascending)
				index[id] = {
					"id" : id,
					"type" : type,
					"sign" : sign,
					"ascending" : ascending,
					"data" : {},
				}
	return index

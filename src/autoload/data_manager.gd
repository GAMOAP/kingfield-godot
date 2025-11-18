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
# USER DATA
# ----------------------------
func get_user_data() -> void:
	get_user_team()
	get_card_index()


# ----------------------------
# USER TEAM
# ----------------------------
func get_user_team() -> Dictionary:
	if not _team:
		_team = await ServerManager.load_data("player_data", "team")
	if _team == {} :
		for char in Global.TEAM:
			var char_stuff : Dictionary
			for type in Global.CARD_TYPE.size():
				var is_card_used:= true
				var card_id := ""
				while is_card_used == true:
					var sign: int = randi() % Global.BREEDS.size()
					var ascendant: int = 0 #randi() % Global.BREEDS.size()
					card_id = str(type) + str(sign) + str(ascendant)
					var is_used = false
					for card_id_tested in _used_cards:
						if card_id_tested == card_id:
							is_used = true
					is_card_used = is_used
				_used_cards.append(card_id)
				char_stuff[str(type)] = card_id
			_team[char] = char_stuff
		save_player_data()
	
	return _team

func update_user_team(char := "", card_id := "") -> void:
	if char != "" && card_id != "":
		var card := str(card_id.to_int() / 100)
		_team[char][card] = card_id

func save_player_data() -> void:
	ServerManager.write_data("player_data", "team", _team, ServerManager.ReadPermissions.PUBLIC_READ)

# ----------------------------
#  ADMIN CARDS INDEX
# ----------------------------
func get_card_index() -> void:
	_card_index = await ServerManager.load_data("global_data", "cards", Global.ADMIN_ID)
	if _card_index == {}:
		_card_index = _create_card_index()

func get_card_data(card_id) -> Dictionary:
	if not _card_index:
		get_card_index()
	return _card_index[card_id]

func get_card_identity(card_id) -> Dictionary:
	var int_id = card_id.to_int()
	var type: int = int_id / 100
	var sign: int = (int_id - type * 100) / 10
	var ascendant: int = int_id - (type + sign)
	return {
		"type" : type,
		"sign" : sign,
		"ascendant" : ascendant,
	}

func set_card_data(data := {}) -> void :
	var card_id = data["id"]
	_card_index[card_id] = data
	
	if is_admin && card_id != "0":
		ServerManager.write_data("global_data", "cards", _card_index, ServerManager.ReadPermissions.PUBLIC_READ)
	else:
		Console.log("Write global_data error : user is not an administrator")

func _create_card_index() -> Dictionary:
	var index := {}
	for type in Global.CARDS.size():
		for sign in Global.BREEDS.size():
			var ascendant := 0
			#for ascendant in Global.BREEDS.size():
			var id = str(type) + str(sign) + str(ascendant)
			index[id] = {
				"id" : id,
				"type" : type,
				"sign" : sign,
				"ascendant" : ascendant,
				"data" : {},
			}
	return index

extends Node

var _device_id : String
var _args = OS.get_cmdline_args()

var _data: Dictionary = {}

const SAVE_PATH := "user://userdata.json"

func _ready() -> void:
	_load_data()
	set_device_id()

func _save_data() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(_data, "\t"))
	file.close()

func _load_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var json = JSON.parse_string(content)
		if json is Dictionary:
			_data = json
	else :
		_data = {}
	Console.log("user_data loaded.")

func get_data(key: String, default_value = null):
	return _data.get(key, default_value)

func set_data(key: String, value) -> void:
	_data[key] = value
	_save_data()

func get_device_id() -> String:
	return _device_id

func set_device_id() ->void:
	_device_id = OS.get_unique_id()
	# set gotot instance device_id to test
	for arg in _args:
		_device_id = arg.replace("--device_id=", "")

func get_user_team() -> Dictionary :
	var team : Dictionary
	if not _data.team :
		for char in Global.CHARS :
			var char_stuff : Dictionary
			for card in Global.CARDS :
				var sign : String = Global.BREEDS[randi() % Global.BREEDS.size()]
				var ascending : String = Global.BREEDS[randi() % Global.BREEDS.size()]
				var card_type : Dictionary = {
					"sign": sign,
					"ascending": ascending
				}
				char_stuff[card] = card_type
			team[char] = char_stuff
		set_data("team", team)
	else :
		team = _data.team
	
	return team

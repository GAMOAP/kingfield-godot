extends Node2D

var _chars : Array[Node]

signal char_selected(char_id)



func _ready() -> void:
	_set_chars()
	

func _set_chars() -> void:
	var teams = get_children()
	for team in teams:
		var chars_temp = team.get_children()
		for char in chars_temp:
			_chars.append(char)
			char.char_clicked.connect(_on_char_clicked)

func _on_char_clicked(char_name, char_team):
	for char in _chars:
		if char.name == char_name && char.team == char_team:
			char.is_selected = true
		else:
			char.is_selected = false

func init_user_team() -> void :
	var user_data = await UserData.get_user_team()
	$user_team.visible = true
	for char in _chars:
		for card in Global.CARDS :
			var sign = user_data[char.name][card]["sign"]
			var ascending = user_data[char.name][card]["ascending"]

func unselect_all():
	for char_temp in _chars:
		char_temp.is_selected = false

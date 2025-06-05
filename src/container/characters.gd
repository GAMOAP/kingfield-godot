extends Node2D

var _chars : Array[Node]


func _ready() -> void:
	_set_chars()
	EventManager.char_clicked.connect(_on_char_clicked)

func _set_chars() -> void:
	var teams = get_children()
	for team in teams:
		var chars_temp = team.get_children()
		for char in chars_temp:
			_chars.append(char)

func _on_char_clicked(char_name, char_team):
	for char in _chars:
		if char.name == char_name && char.team == char_team:
			char.is_selected = true
		else:
			char.is_selected = false

func init_team(team:= Global.SIDE.USER, user_id:= "") -> void :
	var team_data = {}
	if team == Global.SIDE.USER:
		team_data = await UserData.get_user_team()
		$user_team.visible = true
	elif team == Global.SIDE.OPPONENT:
		team_data =  await ServerManagement.load_data("player_data", "team", user_id)
		$opponent_team.visible = true
	
	for char in _chars:
		if char.team == team:
			char.init_char(team_data[char.name])

func unselect_all():
	for char_temp in _chars:
		char_temp.is_selected = false

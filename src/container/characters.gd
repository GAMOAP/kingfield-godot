extends Node2D

var _chars : Array[Node]


func _ready() -> void:
	_set_chars()
	#Global.char_selected = $user_team.get_node("king")
	EventManager.char_clicked.connect(_on_char_clicked)

func _set_chars() -> void:
	var teams = get_children()
	for team in teams:
		var chars_temp = team.get_children()
		for char in chars_temp:
			_chars.append(char)

func _on_char_clicked(char_name: String):
	for char in _chars:
		if char.name == char_name:
			char.is_selected = true
		else:
			char.is_selected = false

func init_team(team:= Global.SIDE.USER, user_id:= "") -> void :
	var team_data = {}
	if team == Global.SIDE.USER:
		team_data = await DataManager.get_user_team()
		$user_team.visible = true
	elif team == Global.SIDE.OPPONENT:
		team_data =  await ServerManager.load_data("player_data", "team", user_id)
		$opponent_team.visible = true
	
	for char in _chars:
		if char.team == team:
			
			char.init_char(team_data[char.name])

func unselect_all():
	for char_temp in _chars:
		char_temp.is_selected = false
	Global.char_selected = null

func get_team_karma(team:= Global.SIDE.USER) -> int:
	var sign_count = {}
	var min_hundreds = {}
	
	var char_data :=[]
	for char in _chars:
		if char.team == team:
			for data in char.get_data().values():
				char_data.append(data)
	
	for str_value in char_data:
		var value = int(str_value)
		var hundreds = int(value / 100)
		var tens = int((value % 100) / 10)
		
		# Count the tens
		sign_count[tens] = sign_count.get(tens, 0) + 1
		# Keep the smallest hundreds digit for this ten
		if not min_hundreds.has(tens) or hundreds < min_hundreds[tens]:
			min_hundreds[tens] = hundreds
	
	# Determine the winning ten
	var karma = 0 #null
	var max_count = 0
	for tens in sign_count:
		var count = sign_count[tens]
		var hundreds = min_hundreds[tens]
		
		if count > max_count or (count == max_count and hundreds < min_hundreds[karma]):
			max_count = count
			karma = tens
	
	return karma
	

extends Node2D

var _units : Array[Node]


func _ready() -> void:
	_set_units()
	#Global.unit_selected = $user_team.get_node("king")
	EventManager.unit_clicked.connect(_on_unit_clicked)
	EventManager.unselect_units.connect(_on_unselect)

func _set_units() -> void:
	var teams = get_children()
	for team in teams:
		var units_temp = team.get_children()
		for unit in units_temp:
			_units.append(unit)

func _on_unit_clicked(unit_name: String, unit_team: Global.SIDE):
	for unit in _units:
		if unit.name == unit_name and unit.team == unit_team:
			unit.is_selected = true
		else:
			unit.is_selected = false

func init_team(team:= Global.SIDE.USER) -> void :
	var team_data = {}
	var team_camp = Global.CAMP.WHITE
	if team == Global.SIDE.USER:
		if MatchManager.current_match:
			team_data = MatchManager.current_match.players["self"]["data"]
			team_camp = MatchManager.current_match.players["self"]["camp"]
		else:
			team_data = await DataManager.get_user_team()
		$user_team.visible = true
	elif team == Global.SIDE.OPPONENT:
		team_data = MatchManager.current_match.players["opponent"]["data"]
		team_camp = MatchManager.current_match.players["opponent"]["camp"]
		$opponent_team.visible = true
	
	for unit in _units:
		unit.reset()
		if unit.team == team:
			unit.init_unit(team_data[unit.name])
			unit.camp = team_camp

func remove_team(team: Global.SIDE) -> void :
	if team == Global.SIDE.USER:
		$user_team.visible = false
	elif team == Global.SIDE.OPPONENT:
		$opponent_team.visible = false

func _on_unselect():
	for unit_temp in _units:
		unit_temp.is_selected = false
	Global.unit_selected = null

func get_team_karma(team :Global.SIDE) -> int:
	var sign_count = {}
	var min_hundreds = {}
	
	var unit_data :=[]
	for unit in _units:
		if unit.team == team:
			for data in unit.get_data().values():
				unit_data.append(data)
	
	for str_value in unit_data:
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
	

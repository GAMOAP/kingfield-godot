extends Node2D


var _char_data: Dictionary

var _karma: int

var _crystal_blue: int
var _crystal_red: int

var _heart: int

var _defense: int
var _attack: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init(char_data: Dictionary) -> void:
	$Karma.frame = get_parent().get_karma()
	_char_data = char_data
	_get_attributes()
	
	set_hearts()
	set_crystals()
	set_defense()
	set_attack()
	set_xp()
	set_buff()

func _get_attributes() -> void:
	
	_crystal_blue = 0 
	_crystal_red = 0
	_heart = 0
	_defense = 0
	_attack = 0
	
	for card_id in _char_data:
		var card_data = DataManager.get_card_data(_char_data[card_id])["data"]
		
		for data in card_data:
			if data == "slot1" or data == "slot2" or data == "slot3":
				#1-CRYSTAL_BLUE, 2-CRYSTAL_RED, 3-LIFE, 4-DEFENSE, 5-ATTACK,
				match int(card_data[data]):
					1 : _crystal_blue += 1
					2 : _crystal_red += 1
					3 : _heart += 1
					4 : _defense += 1
					5 : _attack += 1

func set_hearts() -> void:
	var hearts = $Life.get_children()
	for heart in hearts:
		heart.visible = false
		for nbr in _heart:
			var heart_name := "Life%s" %(nbr + 1)
			if heart.name == heart_name:
				heart.visible = true
				heart.frame = 0

func set_crystals() -> void:
	var crystals = $Crystal.get_children()
	for crystal in crystals:
		crystal.visible = false
		for nbr in (_crystal_blue + _crystal_red):
			var crysal_name := "Crystal%s" %(nbr + 1)
			if crystal.name == crysal_name:
				crystal.visible = true
				if nbr < _crystal_blue :
					crystal.frame = 1
				else :
					crystal.frame = 3

func set_defense() -> void:
	$DefensePicture/Defense_value_front.frame = _defense
	$DefensePicture/Defense_value_back.frame = _defense

func set_attack() -> void:
	$AttackPicture/Attack_value_front.frame = _attack
	$AttackPicture/Attack_value_back.frame = _attack

func set_xp(level := 0) -> void:
	var xp_points = $Xpbar.get_children()
	for xp_point in xp_points:
		xp_point.visible = false
		for nbr in Global.LEVEL[level]:
			var xp_point_name := "Xpbar%s" %(nbr + 1)
			if xp_point.name == xp_point_name:
				xp_point.visible = true
				if nbr == (Global.LEVEL[level] -1):
					xp_point.frame = 2
				else :
					xp_point.frame = 0

func set_buff() -> void:
	$BuffPicture.visible = false

extends Node2D


var _karma: int

var _crystal_blue: int
var _crystal_red: int
var _crystals:int

var _heart: int
var _life: int

var _defense: int
var _attack: int

var _xp: int
var _level:int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init(attributes: Dictionary) -> void:
	$Karma.frame = attributes ["karma"]
	
	_crystal_blue = attributes ["crystal_blue"]
	_crystal_red = attributes ["crystal_red"]
	_crystals = attributes ["crystals"]
	set_crystals()
	
	_heart = attributes ["heart"]
	_life = attributes ["life"]
	set_hearts()
	
	_defense = attributes ["defense"]
	set_defense()
	
	_attack = attributes ["attack"]
	set_attack()
	
	_xp = attributes ["xp"]
	_level = attributes ["level"]
	set_xp()
	
	
	set_buff()

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
		for nbr in (_crystal_red + _crystal_blue):
			var crysal_name := "Crystal%s" %(nbr + 1)
			if crystal.name == crysal_name:
				crystal.visible = true
				
				var actif := 1
				if nbr >= _crystals:
					actif = 0
				
				if nbr < _crystal_red :
					crystal.frame = 2 + actif
				else :
					crystal.frame = 0 + actif

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

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

func init() -> void:
	$Karma.frame = get_parent().get_karma()
	get_attributes(get_parent().get_data())
	
	

func get_attributes(char_data) -> void:
	_crystal_blue = 0
	_crystal_red = 0
	_heart = 0
	_defense = 0
	_attack = 0
	
	for card_id in _char_data:
		var card_data = DataManager.get_card_data(char_data[card_id])["data"]
		for data in card_data:
			if data == "slot1" or data == "slot2" or data == "slot3":
				#1-CRYSTAL_BLUE, 2-CRYSTAL_RED, 3-LIFE, 4-DEFENSE, 5-ATTACK,
				match int(card_data[data]):
					1 : _crystal_blue += 1
					2 : _crystal_red += 1
					3 : _heart += 1
					4 : _defense += 1
					5 : _attack += 1

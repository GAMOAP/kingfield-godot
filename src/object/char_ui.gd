extends Node2D


var _char_name: String

var _char_data: Dictionary

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

func init(char_name: String, char_data: Dictionary) -> void:
	_char_name = char_name
	_char_data = char_data
	print("_________________________________", _char_name)
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
	print(_crystal_blue, _crystal_red, _heart, _defense, _attack)
				

extends Node2D

var _opponent_field :String
var _user_field :String

signal block_clicked(block_id)

@export var grid_position: Vector2


func _ready() -> void:
	name = "block_%d_%d" % [grid_position.x, grid_position.y]
	set_block(0,0,0)
	
func set_block(sign: int, ascendant: int, ascendant_power: int) -> void:
	var quarters = []
	for i in range(4):
		quarters.append(sign)
	
	var indices = []
	for i in range(4):
		indices.append(i)
	indices.shuffle()
	
	for i in range(min(ascendant_power, 3)):
		quarters[indices[i]] = ascendant
	
	for i in 4:
		var block_quarter = get_node("BlockQuarter_%d" % i)
		if block_quarter is Sprite2D:
			block_quarter.frame_coords.y = randi() % (block_quarter.vframes -1)
			block_quarter.frame_coords.x = quarters[i]



func init_block(value_1: int, value_2: int, nbr_value2: int) -> Array:
	var block = []
	
	# Étape 1 : remplir le bloc avec la valeur principale
	for i in range(4):
		block.append(value_1)
	
	# Étape 2 : choisir aléatoirement quels quartiers prendront la valeur secondaire
	var indices = []
	for i in range(4):
		indices.append(i)
	indices.shuffle()
	
	# Étape 3 : assigner la valeur secondaire à nbr_value2 quartiers
	for i in range(min(nbr_value2, 3)): # max 3
		block[indices[i]] = value_2
	
	return block

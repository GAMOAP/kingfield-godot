extends Node2D

var _opponent_field :String
var _user_field :String

signal block_clicked(block_id)

@export var grid_position: Vector2


func _ready() -> void:
	name = "Block_%d_%d" % [grid_position.x, grid_position.y]
	$BlockQuarter_0.frame_coords.y = randi() % 3
	$BlockQuarter_1.frame_coords.y = randi() % 3
	$BlockQuarter_2.frame_coords.y = randi() % 3
	$BlockQuarter_3.frame_coords.y = randi() % 3
	
func _set_block() -> void:
	pass

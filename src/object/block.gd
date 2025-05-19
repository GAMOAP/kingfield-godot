extends Node2D

var _opponent_field :String
var _user_field :String

signal block_clicked(block_id)

@export var grid_position: Vector2


func _ready() -> void:
	name = "block_%d_%d" % [grid_position.x, grid_position.y]
	for block_quarter in get_children():
		if block_quarter is Sprite2D:
			block_quarter.frame_coords.y = randi() % (block_quarter.vframes -1)
	
func _set_block() -> void:
	pass

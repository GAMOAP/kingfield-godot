@tool
extends Node2D

@onready var block = preload("res://src/object/block.tscn")


# Dimensions de la grille
var grid_size = Global.GRID_SIZE
var block_size = Global.CELL_SIZE

func _ready():
	_create_blocks()
	
	EventManager.unselect_all.connect(_on_unselect_all)

func _create_blocks():
	for row in range(grid_size.x):
		for col in range(grid_size.y):
			var block_temp = block.instantiate()
			var pos = Vector2(col, row)
			block_temp.name = "block_" + str(col) + "_" + str(row)
			block_temp.grid_position = pos
			block_temp.position = pos * block_size
			block_temp.visible = false
			add_child(block_temp)

func show_nbr_row(row_nbr:= 0) -> void:
	for row in range(grid_size.x):
		for col in range(grid_size.y):
			var temp_name = "block_" + str(col) + "_" + str(row)
			if row > (4 - row_nbr):
				get_node(temp_name).visible = true
			else :
				get_node(temp_name).visible = false

func set_block_karma(karma: int) -> void:
	for row in range(grid_size.x):
		for col in range(grid_size.y):
			var block = get_node("block_" + str(col) + "_" + str(row))
			block.set_block(0,karma,row)

func _on_unselect_all() -> void:
	for block in $".".get_children():
		block.set_selectable(false)

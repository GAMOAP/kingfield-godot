@tool
extends Node2D

signal block_selected(block_id)

@onready var block = preload("res://src/object/block.tscn")


# Dimensions de la grille
var grid_size = Global.GRID_SIZE
var block_size = Global.CELL_SIZE

func _ready():
	_create_blocks()

func _create_blocks():
	for row in range(grid_size.x):
		for col in range(grid_size.y):
			var block_temp = block.instantiate()
			var pos = Vector2(col, row)
			block_temp.name = "Block_" + str(col) + "_" + str(row)
			block_temp.grid_position = pos
			block_temp.position = pos * block_size
			block_temp.visible = false
			if not Engine.is_editor_hint():
				block_temp.block_clicked.connect(_on_block_clicked)
			add_child(block_temp)

func show_block_row(row:= 5) -> void:
	for block in get_children():
		for col in range(grid_size.y):
			var temp_name = "Block_" + str(col) + "_" + str(row)
			print(block.name, temp_name)
			if block.name == temp_name:
				block.visible = true

func _on_block_clicked(block_id):
	block_selected.emit(block_id)

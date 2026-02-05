@tool
extends Node2D

@onready var block = preload("res://src/object/block.tscn")

# Dimensions de la grille
var grid_size = Global.GRID_SIZE
var block_size = Global.CELL_SIZE

func _ready():
	_create_blocks()
	
	EventManager.unselect_blocks.connect(_on_unselect)

func _create_blocks():
	for row in range(grid_size.x):
		for col in range(grid_size.y):
			var block_temp = block.instantiate()
			var pos = Vector2(col, row)
			block_temp.name = "block_" + str(col) + "_" + str(row)
			block_temp.id = int(str(col) + str(row))
			block_temp.grid_position = pos
			block_temp.position = pos * block_size
			block_temp.visible = false
			$Board.add_child(block_temp)
	
	set_block_label()

func show_nbr_row(row_nbr:= 0) -> void:
	for row in range(grid_size.x):
		for col in range(grid_size.y):
			var temp_name = "block_" + str(col) + "_" + str(row)
			if row > (4 - row_nbr):
				$Board.get_node(temp_name).visible = true
			else :
				$Board.get_node(temp_name).visible = false

func set_block_karma(karma: int, opponent_karma: int) -> void:
	for row in range(grid_size.x):
		for col in range(grid_size.y):
			var block = $Board.get_node("block_" + str(col) + "_" + str(row))
			block.set_block(opponent_karma, karma, row)

func set_block_label() -> void:
	var col_labels = Global.COLUMN_LABELS
	var row_labels = Global.ROW_LABELS
	for row in range(grid_size.x):
		for col in range(grid_size.y):
			var block = $Board.get_node("block_" + str(col) + "_" + str(row))
			block.match_label["col"] = col_labels[col]
			block.match_label["row"] = row_labels[row]
			
			if row >= grid_size.x - 1:
				var col_label = $Labels.get_node("Label_col_" + str(col))
				col_label.text = Global.COLUMN_LABELS[col]
		var row_label = $Labels.get_node("Label_row_" + str(row))
		row_label.text = Global.ROW_LABELS[row]

func _on_unselect() -> void:
	for block in $Board.get_children():
		block.set_selectable(false)

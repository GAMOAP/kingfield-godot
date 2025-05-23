extends Node2D

@onready var board_spot = preload("res://src/admin/board_spot.tscn")
var new_spot 
var new_spot_frame: int = 0: 
	set(value):
		if value > 8:
			value = 0
		if value < 0:
			value = 8
		new_spot_frame = value 
		new_spot.set_frame(new_spot_frame)
		print(new_spot_frame)

func _ready():
	new_spot = board_spot.instantiate()
	new_spot.global_position = Vector2(128, 32)
	add_child(new_spot)

func _on_btn_left_pressed() -> void:
	new_spot_frame += 1

func _on_btn_right_pressed() -> void:
	new_spot_frame -= 1
	

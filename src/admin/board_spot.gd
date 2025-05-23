extends Area2D

var dragging := false
var original_position: Vector2

func _ready():
	original_position = global_position

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
			else:
				dragging = false

				for area in get_overlapping_areas():
					if area.is_in_group("drop_case"):
						global_position = area.global_position
						return

				global_position = original_position

	elif event is InputEventMouseMotion and dragging:
		global_position += event.relative

func set_frame(value)-> void:
	$spot_image.frame = value

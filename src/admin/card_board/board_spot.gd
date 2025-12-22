extends Area2D

var lock := false
var data := {}

var dragging := false
var original_position :Vector2

signal spot_lock_in_area(data: Dictionary)

func _ready():
	original_position = global_position
	

func _input(event):
	if lock == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
						dragging = true
				else:
					dragging = false
					for area in get_overlapping_areas():
						if area.is_in_group("admin_board_slot"):
							global_position = area.global_position
							lock = true
							data = {
								"start" : area.data, "end" : [$spot_image.frame]
							}
							spot_lock_in_area.emit(data)
							return
					global_position = original_position
					

		elif event is InputEventMouseMotion and dragging:
			global_position += event.relative

func set_frame(value)-> void:
	$spot_image.frame = value

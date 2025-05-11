extends Node2D

signal char_clicked(char_id)

@export var grid_position: Vector2
@export var is_selected = false:
	set = _set_selected

@export var is_opponent = false

func _ready() -> void:
	if is_opponent:
		$Sprite2D.scale = Vector2(-0.5, 0.5)
	else:
		$Sprite2D.scale = Vector2(0.5, 0.5)
	$AnimationPlayer.play("idle")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			char_clicked.emit(get_index())

func _set_selected(value):
	is_selected = value
	if is_selected:
		$Sprite2D/char_display.scale = Vector2(1.2, 1.2)
		$Sprite2D/char_display.material.set("shader_parameter/line_thickness", 4)
	else :
		$Sprite2D/char_display.scale = Vector2(1, 1)
		

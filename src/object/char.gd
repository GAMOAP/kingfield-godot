extends Node2D

signal char_clicked(char_name, char_team)

@export var grid_position: Vector2
@export var is_selected = false:
	set = _set_selected

enum TEAM {USER, OPPONENT}
@export var team = TEAM.USER

var outline 

func _ready() -> void:
	is_selected = false
	
	if team == TEAM.OPPONENT:
		$Sprite2D.scale = Vector2(-0.5, 0.5)
	else:
		$Sprite2D.scale = Vector2(0.5, 0.5)
	$AnimationPlayer.play("idle")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			char_clicked.emit(name, team)

func _set_selected(value):
	is_selected = value
	if is_selected:
		$Sprite2D/char_display.scale = Vector2(1.1, 1.1)
		outline.set("shader_parameter/line_thickness", 2)
		outline.set("shader_parameter/line_colour", Color(1,0,0)) #color red
	else :
		if not outline :
			outline = ShaderMaterial.new()
			outline.shader = load("res://src/shaders/outline.gdshader")
			$Sprite2D/char_display.material = outline
			
		$Sprite2D/char_display.scale = Vector2(1, 1)
		outline.set("shader_parameter/line_thickness", 1)
		outline.set("shader_parameter/line_colour", Color(0,0,0)) #color black

func set_texture(card : String, sign : int = 0, asscending : int = 0) -> void :
	match card :
		"breed" :
			$Sprite2D/char_display/head.frame = sign
			$Sprite2D/char_display/face.frame = sign
			$Sprite2D/char_display/hand.frame = sign
		"job" :
			pass
		"helmet" :
			$Sprite2D/char_display/helmet.frame = sign
		"item" :
			pass
		"armor" :
			$Sprite2D/char_display/armor.frame = sign
			$Sprite2D/char_display/arm.frame = sign
		"move" :
			$Sprite2D/char_display/front_leg.frame = sign
			$Sprite2D/char_display/back_leg.frame = sign
		"spell" :
			pass
		"weapon" :
			$Sprite2D/char_display/weapon.frame = sign
		"object" :
			pass
		_:
			pass

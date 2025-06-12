extends Node2D


@export var grid_position: Vector2
@export var is_selected = false:
	set = _set_selected

enum TEAM {USER, OPPONENT}
@export var team = TEAM.USER

var _char_data := {}

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
			EventManager.emit_char_clicked(name, team, _char_data)

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

func init_char(char_data: Dictionary) -> void:
	_char_data = char_data
	for card_id in _char_data:
		_set_texture(_char_data[card_id])
	

func _set_texture(card_id := "") -> void :
	var card_identity = UserData.get_card_identity(card_id)
	var card = card_identity["type"]
	var sign = card_identity["sign"]
	var ascendant = card_identity["ascendant"]
	match card :
		0 : #BREED
			$Sprite2D/char_display/head.frame = sign
			$Sprite2D/char_display/face.frame = sign
			$Sprite2D/char_display/hand.frame = sign
		1 : #JOB
			pass
		2 : #HELMET
			$Sprite2D/char_display/helmet.frame = sign
		3 : #ITEM
			pass
		4 : #ARMOR
			$Sprite2D/char_display/armor.frame = sign
			$Sprite2D/char_display/arm.frame = sign
		5 : #MOVE
			$Sprite2D/char_display/front_leg.frame = sign
			$Sprite2D/char_display/back_leg.frame = sign
		6 : #SPELL
			pass
		7 : #WEAPON
			$Sprite2D/char_display/weapon.frame = sign
		9 : #OBJECT
			pass
		_:
			pass

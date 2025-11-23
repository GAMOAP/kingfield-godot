extends Node2D

var _opponent_field :String
var _user_field :String

signal block_clicked(block_id)

@export var grid_position: Vector2

var original_pos: Vector2
var offset := Vector2(0, 8)
var is_mouse_over := false

var _outline

func _ready() -> void:
	original_pos = position
	
	name = "block_%d_%d" % [grid_position.x, grid_position.y]
	set_block(0,0,0)

func set_block(sign: int, ascendant: int, ascendant_power: int) -> void:
	var quarters = []
	for i in range(4):
		quarters.append(sign)
	
	var indices = []
	for i in range(4):
		indices.append(i)
	indices.shuffle()
	
	for i in range(min(ascendant_power, 4)):
		quarters[indices[i]] = ascendant
	
	for i in 4:
		var block_quarter = get_node("Quarters/BlockQuarter_%d" % i)
		if block_quarter is Sprite2D:
			block_quarter.frame_coords.y = randi() % (block_quarter.vframes -1)
			block_quarter.frame_coords.x = quarters[i]
	
	if not _outline :
		_outline = ShaderMaterial.new()
		_outline.shader = load("res://src/shaders/outline.gdshader")
		$Quarters.material = _outline
		
		_outline.set("shader_parameter/line_thickness", 1)
		_outline.set("shader_parameter/line_colour", Color(0,0,0)) #color black

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if is_mouse_over:
					print(grid_position)
					position = original_pos + offset
			else:
				position = original_pos

func _on_area_2d_mouse_entered() -> void:
	is_mouse_over = true

func _on_area_2d_mouse_exited() -> void:
	is_mouse_over = false
	position = original_pos

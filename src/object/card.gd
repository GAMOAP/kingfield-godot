extends Node2D


signal card_clicked(type, sign, ascending)

@export var _type := Global.CARD_TYPE.MOVE
@export var _sign := Global.BREEDS.DAY
@export var _ascending := Global.BREEDS.DAY

@export var _mana := 0

@export var _board := [
	{"start" : [0, 0], "ends" : [1, 3, 5, 7]},
]

@export var _slot1 := Global.SLOTS.MOVE
@export var _slot2 := Global.SLOTS.MOVE
@export var _slot3 := Global.SLOTS.MOVE

var _spot_outline
var _card_outline

@export var is_selected = false:
	set = _set_selected

func _ready() -> void:
	set_card(0)

func set_card(type, sign = 0, ascending = 0) -> void:
	_type = type
	_sign = sign
	_ascending = ascending
	
	is_selected = false
	
	_set_obj_texture($image, "res://assets/card/"+Global.CARDS[type]+".png")
	$image.frame_coords.x = sign
	$image.frame_coords.y = ascending
	
	set_board()
	set_slots()

func set_backcard(value) -> void:
	$back_card.fame = value

func set_mana(value) -> void:
	if value >= 12:
		_mana = 12
	elif value <= 0:
		_mana = 0
	else :
		value = _mana
	$crystal/number.frame = _mana

func set_slots() -> void:
	$Node2D/slot1.frame = _slot1
	$Node2D/slot2.frame = _slot2
	$Node2D/slot3.frame = _slot3

func set_board():
	if not _spot_outline :
		_spot_outline = ShaderMaterial.new()
		_spot_outline.shader = load("res://src/shaders/outline.gdshader")
	for _spot in _board:
		if _spot["ends"]:
			var ends = _spot["ends"]
			for end in ends:
				var new_spot_end = Sprite2D.new()
				_set_obj_texture(new_spot_end, "res://assets/card/UI/direction.png")
				
				new_spot_end.hframes = 3
				new_spot_end.vframes = 3
				new_spot_end.frame = end
				
				$board_spots.add_child(new_spot_end)
				
		if _spot["start"]:
			var new_spot_start = Sprite2D.new()
			_set_obj_texture(new_spot_start, "res://assets/card/UI/board_char.png")
			$board_spots.add_child(new_spot_start)
	$board_spots.material = _spot_outline 
	_spot_outline.set("shader_parameter/line_thickness", 1.5)
	_spot_outline.set("shader_parameter/line_colour", Color(1,0,0)) #color red



func _set_obj_texture(obj, texture_path :String):
	var image_path = texture_path
	var image = Image.load_from_file(image_path)
	var texture = ImageTexture.create_from_image(image)
	obj.texture = texture

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			card_clicked.emit(_type, _sign, _ascending)

func _set_selected(value):
	is_selected = value
	if is_selected:
		$".".scale = Vector2(1, 1)
	else :
		$".".scale = Vector2(0.6, 0.6)

func get_card_attributes() -> Dictionary:
	var attributes := {
		"type" : _type,
		"sign" : _sign,
		"ascending" : _ascending,
		"mana" : _mana,
		"slot1" : _slot2,
		"slot2" : _slot2,
		"slot3" : _slot3,
		"board" : _board,
	}
	return attributes

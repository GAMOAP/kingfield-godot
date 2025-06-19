extends Node2D

var _card_id := ""

const _slot_size:int = 16

@export var _type: Global.CARD_TYPE
@export var _sign: Global.BREEDS
@export var _ascendant: Global.BREEDS

var _spot_outline
var _card_outline

@export var is_selected = false:
	set = _set_selected

func _ready() -> void:
	is_selected = false
	visible = false
	
	EventManager.admin_card_subit.connect(reset_card)

func set_card(card_id) -> void:
	_card_id = card_id
	var card = await UserData.get_card_data(card_id)
	var card_data = card["data"]
	
	var card_identity = UserData.get_card_identity(card_id)
	_type = card_identity["type"]
	_sign = card_identity["sign"]
	_ascendant = card_identity["ascendant"]
	
	if card_data.get("rarity"):
		set_backcard(card_data["rarity"])
	
	set_texture()
	
	if card_data.get("mana"):
		set_mana(int(card_data["mana"]))
		$crystal.visible = true
	else:
		$crystal.visible = false
	
	if card_data.get("board"):
		set_board(card_data["board"])
		$board.visible = true
		$board_spots.visible = true
	else:
		$board.visible = false
		$board_spots.visible = false
	
	for slot_nbr in 3:
		var slot_path := "Node2D/slot%d" % (slot_nbr + 1)
		var slot = get_node(slot_path)
		if card_data.get(slot.name):
			set_slots(slot,card_data[slot.name])
			slot.visible = true
		else:
			slot.visible = false
	visible = true

func reset_card(card_id) -> void:
	if card_id == _card_id:
		set_card(card_id)

#SET CARD FUNCIONS
#---------------------
func set_backcard(value) -> void:
	$back_card.fame = value

func set_texture() -> void:
	_set_obj_texture($image, "res://assets/card/"+Global.CARDS[_type]+".png")
	$image.frame_coords.x = _sign
	$image.frame_coords.y = _ascendant

func set_mana(value) -> void:
	var mana: int
	if value >= 12:
		mana = 12
	elif value <= 0:
		mana = 0
	else :
		mana = value
	$crystal/number.frame = mana
	$crystal/number.visible = true

func set_slots(slot, value) -> void:
	slot.frame = value

func set_board(board):
	print(board)
	for spot in $board_spots.get_children():
		spot.queue_free()
	if not _spot_outline :
		_spot_outline = ShaderMaterial.new()
		_spot_outline.shader = load("res://src/shaders/outline.gdshader")
	for spot in board:
		var ends = spot["end"]
		var start = spot["start"]
		for end in ends:
			var new_spot = Sprite2D.new()
			_set_obj_texture(new_spot, "res://assets/card/UI/direction.png")
			
			new_spot.hframes = 3
			new_spot.vframes = 3
			new_spot.frame = int(end)
			
			var x = start[0] * _slot_size
			var y = -start[1] * _slot_size
			var pos = Vector2(x, y)
			new_spot.position = pos
			$board_spots.add_child(new_spot)
				
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
			if not is_selected:
				EventManager.emit_card_clicked(_card_id)

func _set_selected(value):
	is_selected = value
	if is_selected:
		$".".scale = Vector2(0.8, 0.8)
	else :
		$".".scale = Vector2(0.6, 0.6)

func get_card_id() -> String:
	return _card_id

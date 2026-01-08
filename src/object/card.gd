extends Node2D

var _card_id := ""
var _card_size := 1.0
var _container := Global.CONTAINER.NONE

var _card_data := {}

var _char_selected = null

const _slot_size:int = 16

@export var _type: Global.CARD_TYPE
@export var _sign: Global.BREEDS
@export var _ascendant: Global.BREEDS

var _spot_outline
var _card_outline

@export var is_selected = false:
	set = _set_selected

var slot_selected = 0:
	set = _set_slot_selected

var is_selectable = true

var is_playable = true

func _ready() -> void:
	is_selected = false
	visible = false
	
	add_to_group("cards")
	
	EventManager.admin_card_subit.connect(reset_card)

# card_id is '000' type,sign,ascendant
func set_card(card_id, container, card_size = 1) -> void:
	_container = container
	_card_size = card_size
	$".".scale = Vector2(_card_size * 1, _card_size * 1)
	
	_card_id = card_id
	_char_selected = Global.char_selected
	
	var card = await DataManager.get_card_data(card_id)
	_card_data = card["data"]
	
	var card_identity = DataManager.get_card_identity(card_id)
	_type = card_identity["type"]
	_sign = card_identity["sign"]
	_ascendant = card_identity["ascendant"]
	
	if _card_data.get("rarity"):
		set_backcard(_card_data["rarity"])
	
	set_texture()
	
	if _card_data.get("mana"):
		set_mana(int(_card_data["mana"]))
		$crystal.visible = true
	else:
		$crystal.visible = false
	
	if _card_data.get("board"):
		set_board(_card_data["board"])
		$board.visible = true
		$board_spots.visible = true
		$char_spot.visible = true
	else:
		$board.visible = false
		$board_spots.visible = false
		$char_spot.visible = false
	
	for slot_nbr in range(1, 4):
		var slot_path := "Node2D/slot%d" % slot_nbr
		var slot = get_node(slot_path)
		if _card_data.get(slot.name):
			set_slots(slot, _card_data[slot.name])
			slot.visible = true
		else:
			slot.visible = false
	visible = true

func reset_card(card_id) -> void:
	if card_id == _card_id:
		set_card(card_id, _container, _card_size)

#---------------------
# SET CARD FUNCIONS
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
	
	if _char_selected.get_attributes()["crystals"] < mana:
		$crystal.frame = 1
		is_playable = false
	else: 
		$crystal.frame = 0
		is_playable = true

func set_slots(slot, value) -> void:
	slot.frame = value

func set_board(board):
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
			var y = start[1] * _slot_size
			var pos = Vector2(x, y)
			new_spot.position = pos
			$board_spots.add_child(new_spot)
				
	$board_spots.material = _spot_outline 
	_spot_outline.set("shader_parameter/line_thickness", 1.5)
	_spot_outline.set("shader_parameter/line_colour", Color(1,0,0)) #color red
	
	if _char_selected.team == Global.SIDE.OPPONENT:
		$board_spots.scale = Vector2(1, -1)
	else:
		$board_spots.scale = Vector2(1, 1)
		
func _set_obj_texture(obj, texture_path :String):
	var image_path = texture_path
	var image = Image.load_from_file(image_path)
	var texture = ImageTexture.create_from_image(image)
	obj.texture = texture

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not is_selected and _char_selected.team == Global.SIDE.USER:
				Global.card_selected = self
				EventManager.emit_card_clicked(_card_id)

func _set_selected(value):
	is_selected = value
	if is_selected:
		$".".scale = Vector2(_card_size * 1.2, _card_size * 1.2)
	else :
		$".".scale = Vector2(_card_size * 1, _card_size * 1)
		if _container == Global.CONTAINER.DECK:
			_set_slot_selected(0)

func _set_slot_selected(value):
	slot_selected = value
	for slot_nbr in range(1, 4):
		var slot_path := "Node2D/slot%d" % slot_nbr
		var slot = get_node(slot_path)
		if slot_selected == slot_nbr and _type > 4:
			slot.scale = Vector2(1.3, 1.3)
		else :
			slot.scale = Vector2(1, 1)

func get_id() -> String:
	return _card_id

func get_container() -> Global.CONTAINER:
	return _container

func get_data() -> Dictionary:
	return _card_data

func _on_area_2d_mouse_entered() -> void:
	pass # Replace with function body.

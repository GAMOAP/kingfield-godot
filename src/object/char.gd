extends Node2D

var origin_grid_position: Vector2
var origin_position: Vector2

@export var grid_position: Vector2
@export var is_selected = false:
	set = _set_selected
@export var is_selectable = true

enum TEAM {USER, OPPONENT}
@export var team = TEAM.USER

var _char_data := {}

var outline 

func _ready() -> void:
	is_selected = false
	
	add_to_group("chars")
	
	origin_grid_position = grid_position
	origin_position = position
	
	if team == TEAM.OPPONENT:
		$Sprite2D.scale = Vector2(-0.5, 0.5)
	else:
		$Sprite2D.scale = Vector2(0.5, 0.5)
	$AnimationPlayer.play("idle")
	
	EventManager.deck_card_submit.connect(_on_deck_card_submit)

func init_char(char_data: Dictionary) -> void:
	_char_data = char_data
	
	for card_id in _char_data:
		_set_texture(_char_data[card_id])
	
	$Char_UI.init(_char_data)

func reset() -> void:
	grid_position = origin_grid_position
	position = origin_position
# ----------------------------
# EVENT ACTION
# ----------------------------
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_selectable == true and self != Global.char_selected :
				Global.char_selected = self
				EventManager.emit_char_clicked(name)

func _on_deck_card_submit(card_id: String) -> void:
	if Global.char_selected.get_name() == name and team == TEAM.USER:
		_char_data = DataManager.get_char_data(name)
		$Char_UI.init(_char_data)
		_set_texture(card_id)

# ----------------------------
# SELECT
# ----------------------------
func _set_selected(value):
	is_selected = value
	if is_selected:
		$Sprite2D/char_display.scale = Vector2(1.1, 1.1)
		$Char_UI.visible = true
		$Char_UI.scale = Vector2(1.1, 1.1)
		outline.set("shader_parameter/line_thickness", 2)
		outline.set("shader_parameter/line_colour", Color(1,0,0)) #color red
	else :
		if not outline :
			outline = ShaderMaterial.new()
			outline.shader = load("res://src/shaders/outline.gdshader")
			$Sprite2D/char_display.material = outline
			
		$Sprite2D/char_display.scale = Vector2(1, 1)
		$Char_UI.visible = false
		$Char_UI.scale = Vector2(1, 1)
		outline.set("shader_parameter/line_thickness", 1)
		outline.set("shader_parameter/line_colour", Color(0,0,0)) #color black

# ----------------------------
# TEXTURE
# ----------------------------
func _set_texture(card_id := "") -> void :
	var card_identity = DataManager.get_card_identity(card_id)
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

# ----------------------------
# ACTION
# ----------------------------
func move_to_cell(target_grid: Vector2) -> void:
	var target_pos = target_grid * Global.CELL_SIZE
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",target_pos,0.3)
	
	await  tween.finished
	grid_position = target_grid

# ----------------------------
# FUNCTION GET
# ----------------------------
func get_data() -> Dictionary:
	_char_data = DataManager.get_char_data(name)
	return _char_data

func get_attributes() -> Dictionary:
	var attributes := {
		"crystal_blue" : 0,
		"crystal_red" : 0,
		"crystals": 0,
		"heart" : 0,
		"defense" : 0,
		"attack" : 0
	}
	
	for card_id in _char_data:
		var card_data = DataManager.get_card_data(_char_data[card_id])["data"]
		
		for data in card_data:
			if data == "slot1" or data == "slot2" or data == "slot3":
				#1-CRYSTAL_BLUE, 2-CRYSTAL_RED, 3-LIFE, 4-DEFENSE, 5-ATTACK,
				match int(card_data[data]):
					1 : attributes["crystal_blue"] += 1
					2 : attributes["crystal_red"] += 1
					3 : attributes["heart"] += 1
					4 : attributes["defense"] += 1
					5 : attributes["attack"] += 1
	
	attributes["crystals"] =  attributes["crystal_blue"] + attributes["crystal_red"]
	
	return attributes

func get_karma() -> int:
	var sign_count = {}
	var min_hundreds = {}
	
	for str_value in _char_data.values():
		var value = int(str_value)
		var hundreds = int(value / 100)
		var tens = int((value % 100) / 10)
		
		# Count the tens
		sign_count[tens] = sign_count.get(tens, 0) + 1
		# Keep the smallest hundreds digit for this ten
		if not min_hundreds.has(tens) or hundreds < min_hundreds[tens]:
			min_hundreds[tens] = hundreds
	
	# Determine the winning ten
	var karma = null
	var max_count = 0
	for tens in sign_count:
		var count = sign_count[tens]
		var hundreds = min_hundreds[tens]
		
		if count > max_count or (count == max_count and hundreds < min_hundreds[karma]):
			max_count = count
			karma = tens
	
	return karma

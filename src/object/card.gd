extends Node2D


signal card_clicked(block_id)

@export var type := Global.CARD_TYPE.MOVE
@export var sign := Global.BREEDS.DAY
@export var ascending := Global.BREEDS.DAY

@export var mana:int :
	set(value):
		if value >= 12:
			mana = 12
		elif value <= 0:
			mana = 0
		else :
			mana = value
	get:
		return mana

@export var board := [
	{"start" : [0, 0], "ends" : [1, 3, 5, 7]},
]

@export var slot1 := Global.SLOTS.MOVE
@export var slot2 := Global.SLOTS.MOVE
@export var slot3 := Global.SLOTS.MOVE
		
func get_card_attributes() -> Dictionary:
	var attributes := {
		"type" : type,
		"sign" : sign,
		"ascending" : ascending,
		"mana" : mana,
		"slot1" : slot2,
		"slot2" : slot2,
		"slot3" : slot3,
		"board" : board,
	}
	return attributes
	
func _ready() -> void:
	print(type)
	_set_obj_texture($CanvasGroup/image, "res://assets/card/"+Global.CARDS[type]+".png")
	$CanvasGroup/crystal/number.frame = mana
	$CanvasGroup/Node2D/slot1.frame = slot1
	$CanvasGroup/Node2D/slot2.frame = slot2
	$CanvasGroup/Node2D/slot3.frame = slot3

func _set_obj_texture(obj, texture_path :String):
	var image_path = texture_path
	var image = Image.load_from_file(image_path)
	var texture = ImageTexture.create_from_image(image)
	obj.texture = texture

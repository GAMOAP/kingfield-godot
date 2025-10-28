extends Node2D

var _id : String
var _type : int
var _sign : int
var _ascendant : int

@onready var slot1_list: OptionButton = $Panel/slot1/slot1_list
@onready var slot2_list: OptionButton = $Panel/slot2/slot2_list
@onready var slot3_list: OptionButton = $Panel/slot3/slot3_list


func _ready() -> void:
	for slot in Global.SLOTS.keys():
		slot1_list.add_item(slot.capitalize())
		slot2_list.add_item(slot.capitalize())
		slot3_list.add_item(slot.capitalize())
	
	EventManager.card_clicked.connect(_on_card_clicked)

func _on_submit_pressed() -> void:
	
	var data := {
		"mana" : int($Panel/mana/SpinBox.value),
		"slot1" : int($Panel/slot1/slot1_list.selected),
		"slot2" : int($Panel/slot2/slot2_list.selected),
		"slot3" : int($Panel/slot3/slot3_list.selected),
		"board" : $Panel/admin_card_board.get_spot_list()
	}
	var card_data := {
		"id" : _id,
		"type" : _type,
		"sign" : _sign,
		"ascendant" : _ascendant,
		"data" : data,
	}
	
	UserData.set_card_data(card_data)
	EventManager.emit_admin_card_submit(_id)

func _on_card_clicked(card_id, container) -> void:
	_id = card_id
	var card_data = await UserData.get_card_data(_id)
	
	_type = card_data["type"]
	$Panel/type/card_type.text = str(Global.CARD_TYPE.find_key(_type))
	_sign = card_data["sign"]
	$Panel/sign/card_sign.text = str( Global.BREEDS.find_key(_sign))
	_ascendant = card_data["ascendant"]
	$Panel/ascendant/card_ascendant.text = str(Global.BREEDS.find_key(_ascendant))
	
	var data: Dictionary = card_data["data"]
	if data.get("mana"):
		$Panel/mana/SpinBox.value = data["mana"]
	else:
		$Panel/mana/SpinBox.value = 0
	
	
	for slot_nbr in 3:
		var slot_name = "slot%d" % (slot_nbr + 1)
		var slot_path := "Panel/%s/%s_list" % [slot_name, slot_name]
		var slot_list = get_node(slot_path)
		if data.get(slot_name):
			slot_list.selected = data[slot_name]
		else:
			slot_list.selected = 0

	
	if data.get("board"):
		var spot_list: Array = data["board"]
		$Panel/admin_card_board.set_spot_list(spot_list)
	else:
		$Panel/admin_card_board.set_spot_list([])
		
	

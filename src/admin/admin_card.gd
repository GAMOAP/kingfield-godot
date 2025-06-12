extends Node2D

@onready var slot_1_list: OptionButton = $Panel/slot_1/slot_1_list
@onready var slot_2_list: OptionButton = $Panel/slot_2/slot_2_list
@onready var slot_3_list: OptionButton = $Panel/slot_3/slot_3_list


func _ready() -> void:
	for slot in Global.SLOTS.keys():
		slot_1_list.add_item(slot.capitalize())
		slot_2_list.add_item(slot.capitalize())
		slot_3_list.add_item(slot.capitalize())
	
	EventManager.card_clicked.connect(_on_card_clicked)

func _on_submit_pressed() -> void:
	var card := {
		"type" : $Panel/type/card_type.text,
		"sign" : $Panel/sign/card_sign.text,
		"ascendant" : $Panel/ascendant/card_ascendant.text,
		"mana" : $Panel/mana/SpinBox.value,
		"slot_1" : $Panel/slot_1/slot_1_list.get_item_text($Panel/slot_1/slot_1_list.selected),
		"slot_2" : $Panel/slot_2/slot_2_list.get_item_text($Panel/slot_2/slot_2_list.selected),
		"slot_3" : $Panel/slot_3/slot_3_list.get_item_text($Panel/slot_3/slot_3_list.selected),
		"board" : $Panel/admin_card_board.get_spot_list()
	}
	print(card)

func _on_card_clicked(card_id) -> void:
	var card_data = UserData.get_card_data(card_id)
	$Panel/type/card_type.text = str(Global.CARD_TYPE.find_key(card_data["type"]))
	$Panel/sign/card_sign.text = str(Global.BREEDS.find_key(card_data["sign"]))
	$Panel/ascendant/card_ascendant.text = str(Global.BREEDS.find_key(card_data["ascendant"]))
	
	var data: Dictionary = card_data["data"]
	if data.get("mana"):
		$Panel/mana/SpinBox.value = data["mana"]
	
	if data.get("slot_1"):
		$Panel/slot_1/slot_1_list.selected = data["slot_1"]
	if data.get("slot_2"):
		$Panel/slot_1/slot_1_list.selected = data["slot_2"]
	if data.get("slot_3"):
		$Panel/slot_1/slot_1_list.selected = data["slot_3"]
	
	#if data.get("board"):
		#var spot_list: Array = data["board"]
	var spot_list: Array = [{ "start": [0, 0], "end": [1, 2, 8] }]
	$Panel/admin_card_board.set_spot_list(spot_list)

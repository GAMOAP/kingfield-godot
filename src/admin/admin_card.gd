extends Node2D

@onready var slot_1_list: OptionButton = $Panel/slot_1/slot_1_list
@onready var slot_2_list: OptionButton = $Panel/slot_2/slot_2_list
@onready var slot_3_list: OptionButton = $Panel/slot_3/slot_3_list
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slot in Global.SLOTS.keys():
		slot_1_list.add_item(slot.capitalize())
		slot_2_list.add_item(slot.capitalize())
		slot_3_list.add_item(slot.capitalize())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_submit_pressed() -> void:
	var card := {
		"type" : $Panel/type/card_type.text,
		"sign" : $Panel/sign/card_sign.text,
		"ascendent" : $Panel/ascendent/card_ascendent.text,
		"mana" : $Panel/mana/SpinBox.value,
		"slot_1" : $Panel/slot_1/slot_1_list.get_item_text($Panel/slot_1/slot_1_list.selected),
		"slot_2" : $Panel/slot_2/slot_2_list.get_item_text($Panel/slot_1/slot_1_list.selected),
		"slot_3" : $Panel/slot_3/slot_3_list.get_item_text($Panel/slot_1/slot_1_list.selected),
		"board" : $Panel/admin_card_board.get_spot_list()
	}
	print(card)
	
	

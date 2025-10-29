@tool
extends Node2D

@onready var btn_active = $background/btn_active
@onready var btn_passive = $background/btn_passive

@onready var card_active = $background/active
@onready var card_passive = $background/passive

var _active := true
var _passive := false

var _card_size := 0.9
var _container := Global.CONTAINER.DECK

var _cards: Array

var _char_selected_data := {}

func _ready() -> void:
	$background.visible = false
	switch_cards_active(true)
	EventManager.char_clicked.connect(_on_char_clicked)
	EventManager.card_clicked.connect(_on_card_clicked)
	EventManager.deck_card_submit.connect(_on_deck_card_submit)

func open() -> void:
	$background.visible = true
	if _cards == []:
		init_cards()

func close() -> void:
	$background.visible = false

func init_cards() -> void:
	var actives = $background/active.get_children()
	var passives = $background/passive.get_children()

	# 5 à 9 = actives
	for i in actives.size():
		var type = 5 + i
		var card_id = _char_selected_data[str(type)]
		_cards.append(actives[i])
		actives[i].set_card(card_id, _container, _card_size)

	# 0 à 4 = passives
	for j in passives.size():
		var type = 0 + j
		var card_id = _char_selected_data[str(type)]
		_cards.append(passives[j])
		passives[j].set_card(card_id, _container, _card_size)

func select_card(card_id, container) -> void:
	for card in _cards:
		if card.get_id() == card_id && card.get_container() == container:
			card.is_selected = true
		elif card.get_container() == container:
			card.is_selected = false

func switch_cards_active(active : bool) -> void:
	var passive := true
	if active == true :
		passive = false
		
	card_active.visible = active
	card_passive.visible = passive

func _on_char_clicked(name: String, team: int, data: Dictionary) -> void:
	_char_selected_data = data
	init_cards()

func _on_card_clicked(card_id: String, container: Global.CONTAINER) -> void:
	select_card(card_id, container)

func _on_deck_card_submit(char_id: String, card_id: String) -> void:
	_char_selected_data[str(card_id.to_int() / 100)] = card_id
	init_cards()

func _on_btn_active_pressed() -> void:
	switch_cards_active(true)
	

func _on_btn_passive_pressed() -> void:
	switch_cards_active(false)
	

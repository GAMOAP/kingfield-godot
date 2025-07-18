@tool
extends Node2D

var _library_page := [0, 0]

var _admin_card

var _cards: Array

var _char_selected_data := {}

func _ready() -> void:
	$background.visible = false
	EventManager.card_clicked.connect(_on_card_clicked)
	EventManager.char_clicked.connect(_on_char_clicked)

func open() -> void:
	$background.visible = true
	if _cards == []:
		init_cards(_library_page[0])
	if UserData.is_admin == true :
		if not _admin_card:
			_admin_card = preload("res://src/admin/admin_card.tscn").instantiate()
			add_child(_admin_card)
		_admin_card.visible = true

func close() -> void:
	$background.visible = false
	if UserData.is_admin == true :
		_admin_card.visible = false

func init_cards(page := Global.CARD_TYPE.BREED) -> void:
	_library_page[0] = page
	_cards = $background/cards.get_children()
	
	for card in _cards:
		var card_id = str(_library_page[0]) + str(card.get_index()) + str(0)
		card.set_card(card_id)

func select_card(card_id) -> void:
	for card in _cards:
		if card.get_card_id() == card_id:
			card.is_selected = true
		else:
			card.is_selected = false

func _on_char_clicked(name: String, team: int, data: Dictionary) -> void:
	_char_selected_data = data
	var card_select_id = _char_selected_data[str(_library_page[0])]
	if _cards == []:
		init_cards(_library_page[0])
	for card in _cards:
		if card.get_card_id() == card_select_id :
			select_card(card_select_id)

func _on_btn_close_pressed() -> void:
	EventManager.set_scene.emit(Global.SCENES.HOME)

func _on_card_clicked(card_id: String) -> void:
	select_card(card_id)


func _on_btn_left_pressed() -> void:
	var page = _library_page[0] - 1
	if page < 0 :
		page = 8
	init_cards(page)

func _on_btn_right_pressed() -> void:
	var page = _library_page[0] + 1
	if page > 8 :
		page = 0
	init_cards(page)

@tool
extends Node2D

var _container := Global.CONTAINER.LIBRARY

var _library_page := [0, 0]

var _admin_card

var _cards: Array

var _char_selected_data := {}

func _ready() -> void:
	$background.visible = false

func open() -> void:
	$background.visible = true
	EventManager.card_clicked.connect(_on_card_clicked)
	EventManager.char_clicked.connect(_on_char_clicked)
	
	_char_selected_data = Global.char_selected.get_data()
	if DataManager.is_admin == true :
		if not _admin_card:
			_admin_card = preload("res://src/admin/admin_card.tscn").instantiate()
			$".".add_child(_admin_card)
			
		_admin_card.visible = true
	
	init_cards(_library_page[0])

func close() -> void:
	$background.visible = false
	EventManager.card_clicked.disconnect(_on_card_clicked)
	EventManager.char_clicked.disconnect(_on_char_clicked)
	
	if _admin_card and DataManager.is_admin == true :
		_admin_card.visible = false

func init_cards(page := Global.CARD_TYPE.BREED) -> void:
	_library_page[0] = page
	EventManager.emit_library_page_change(_library_page[0])
	var card_select_id = _char_selected_data[str(_library_page[0])]
	
	if _cards == []:
		_cards = $background/cards.get_children()
	
	for card in _cards:
		var card_id = str(_library_page[0]) + str(card.get_index()) + str(0)
		card.set_card(card_id, _container, 0.6)
		if card.get_id() == card_select_id :
			select_card(card_select_id)

func select_card(card_id) -> void:
	for card in _cards:
		if card.get_id() == card_id:
			card.is_selected = true
			if _char_selected_data[str(card_id.to_int() / 100)] != card_id:
				DataManager.update_user_team(Global.char_selected.name, card_id)
				EventManager.emit_deck_card_submit(card_id)
		else:
			card.is_selected = false

func _on_char_clicked(name: String, team: Global.SIDE) -> void:
	_char_selected_data = Global.char_selected.get_data()
	var card_select_id = _char_selected_data[str(_library_page[0])]
	init_cards(_library_page[0])

func _on_btn_close_pressed() -> void:
	DataManager.save_player_data()
	EventManager.set_scene.emit(Global.SCENES.HOME)

func _on_card_clicked(card_id: String) -> void:
	if Global.card_selected.get_container() == _container:
		select_card(card_id)
	if Global.card_selected.get_container() == Global.CONTAINER.DECK:
		var card_type: Global.CARD_TYPE = card_id.to_int() / 100
		init_cards(card_type)

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

@tool
extends Node2D

signal library_action(action)
signal card_selected(card_type, char_sign, char_ascending)

var _admin_card

var _library_page := [0, 0]

var _cards: Array

func _ready() -> void:
	$background.visible = false

func start() -> void:
	$background.visible = true
	init_cards(_library_page[0])
	if UserData.is_admin == true :
		if not _admin_card:
			_admin_card = preload("res://src/admin/admin_card.tscn").instantiate()
			add_child(_admin_card)
		_admin_card.visible = true

func stop() -> void:
	$background.visible = false
	if UserData.is_admin == true :
		_admin_card.visible = false

func init_cards(page := Global.CARD_TYPE.BREED) -> void:
	_library_page[0] = page
	var _cards = $background/cards.get_children()
	
	for card in _cards:
		var type = _library_page[0]
		var sign = card.get_index()
		var ascending = 0
		card.set_card(type, sign, ascending)
		card.card_clicked.connect(_on_card_clicked)

func _on_btn_close_pressed() -> void:
	library_action.emit("stop")

func _on_card_clicked(card_type, char_sign, char_ascending):
	for card in _cards:
		if card.type == card_type && card.sign == char_sign && card.ascending == char_ascending:
			card.is_selected = true
			card_selected.emit(card_type, char_sign, char_ascending)
		else:
			card.is_selected = false


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

@tool
extends Node2D

@onready var btn_active = $background/btn_active
@onready var btn_passive = $background/btn_passive

@onready var card_active = $background/active
@onready var card_passive = $background/passive

var _card_size := 0.9
var _container := Global.CONTAINER.DECK

var _cards := []

var _char_selected_data := {}

func _ready() -> void:
	switch_cards_active(true)
	EventManager.char_clicked.connect(_on_char_clicked)
	EventManager.card_clicked.connect(_on_card_clicked)
	EventManager.library_page_change.connect(_on_library_page_change)
	EventManager.deck_card_submit.connect(_on_deck_card_submit)

func open() -> void:
	$background.visible = true
	if Global.char_selected != null:
		_char_selected_data = Global.char_selected.get_data() 

func close() -> void:
	$background.visible = false

func _init_cards() -> void:
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

func _set_cards() -> void:
	if _cards == [] :
		_init_cards()
	else :
		for card in _cards:
			var type = int(card.get_id()) / 100
			var card_id = _char_selected_data[str(type)]
			card.set_card(card_id, _container, _card_size)

func _select_card(card_id) -> void:
	var card_id_type = card_id.to_int()/100
	for card in _cards:
		var tested_card_id = card.get_id()
		if tested_card_id.to_int()/100 == card_id_type:
			card.is_selected = true
		else:
			card.is_selected = false

func switch_cards_active(active : bool) -> void:
	var passive := true
	btn_passive.button_pressed = true
	if active == true :
		btn_active.button_pressed = true
		passive = false
		
	card_active.visible = active
	card_passive.visible = passive

func _on_char_clicked(name: String) -> void:
	_char_selected_data = Global.char_selected.get_data()
	_set_cards()

func _on_card_clicked(card_id: String) -> void:
	if Global.card_selected.get_container() == _container:
		_select_card(card_id)
	elif Global.card_selected.get_container() == Global.CONTAINER.LIBRARY:
		var card_type: Global.CARD_TYPE = card_id.to_int() / 100
		if card_type >= 5:
			switch_cards_active(true)
		else :
			switch_cards_active(false)
		
		_select_card(card_id)

func _on_library_page_change(page: int) -> void:
	if page >= 5:
		switch_cards_active(true)
	else :
		switch_cards_active(false)
	for card in _cards:
		var card_id :String = card.get_id()
		if card_id.to_int() / 100 == page:
			_select_card(card_id)

func _on_deck_card_submit(card_id: String) -> void:
	_char_selected_data[str(card_id.to_int() / 100)] = card_id
	_set_cards()
	_select_card(card_id)

func _on_btn_active_pressed() -> void:
	switch_cards_active(true)
	

func _on_btn_passive_pressed() -> void:
	switch_cards_active(false)
	

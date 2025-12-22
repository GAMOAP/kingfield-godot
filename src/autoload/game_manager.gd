extends Node


const board_block = [Vector2(0,0), Vector2(0,-1), Vector2(1,-1),
					Vector2(1,0), Vector2(1,1), Vector2(0,1), 
					Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1)]

var _char_selected = null
var _card_selected = null
var _block_selected = null
var _blocks_selectables = []
var _slot_selected = 1
var _actions = []

var _action_map = {}

var active = false

func start_game():
	active = true
	EventManager.char_clicked.connect(_on_char_selected)
	EventManager.card_clicked.connect(_on_card_selected)
	EventManager.block_clicked.connect(_on_block_selected)
	
	_start_turn()

func end_game():
	active = false
	EventManager.char_clicked.disconnect(_on_char_selected)
	EventManager.card_clicked.disconnect(_on_card_selected)
	EventManager.block_clicked.disconnect(_on_block_selected)

func _start_turn():
	if not active: return
	_char_selected = null
	_card_selected = null
	_slot_selected = 1
	_actions = []
	_reset_selectable_blocks()
	EventManager.emit_unselect_all()

func _on_char_selected(char_id):
	if not active: return
	_char_selected = Global.char_selected
	_card_selected = null
	_slot_selected = 1
	_actions = []
	EventManager.emit_unselect_cards()
	_reset_selectable_blocks()

func _on_card_selected(card):
	if not active or _char_selected == null: return
	_card_selected = Global.card_selected
	_actions = []
	_reset_selectable_blocks()
	_set_selectables_block()

func _on_block_selected(block_name):
	if not active: return
	_block_selected = Global.block_selected
	
	var block_selectable = false
	for selectable in _blocks_selectables:
		if _block_selected.grid_position == selectable:
			block_selectable = true
	
	var block_empty = true
	for char in get_tree().get_nodes_in_group("chars"):
		if char.grid_position == _block_selected.grid_position :
			if block_selectable == true:
				char.is_selectable = false
			block_empty = false
	
	var action = {
		"char" = _char_selected,
		"card" = _card_selected,
		"block" = _block_selected,
		"slot" = _slot_selected,
	}

	if block_selectable == true:
		_actions.append(action)
		_resolve_slot()
	elif block_empty == true :
		_start_turn()

func _resolve_slot():
	_slot_selected += 1
	var slot = _card_selected.get_data().get("slot%s" % _slot_selected)
	if not slot:
		_resolve_action()
	else:
		_set_selectables_block()

func _resolve_action():
	for char in get_tree().get_nodes_in_group("chars"):
		char.is_selectable = false
	
	EventManager.emit_unselect_all()
	
	for act in _actions:
		var card = act["card"]
		var slot = act["slot"]
		
		var action_nbr = card.get_data().get("slot%s" % slot)
		var action_type
		for key in Global.SLOTS.keys():
			if Global.SLOTS[key] == action_nbr:
				action_type = key
		
		if not _action_map.has(slot):
			var action_path = "res://src/actions/%s.gd" % action_type.to_lower()
			if FileAccess.file_exists(action_path):
				var action = load(action_path)
				if action:
					_action_map[action_type] = action.new()
					
		var executor = _action_map[action_type]
		executor.execute(act)


func _end_turn():
	print("Fin du tour.")


func _set_selectables_block() -> void:
	_blocks_selectables = []
	
	if _char_selected == null or _card_selected == null: return
	
	var board = _card_selected.get_data().get('board')
	if not board: return
	
	for path in board:
		var start := Vector2(path["start"][0], path["start"][1])
		var ends = path["end"]
		
		for end in ends:
			var block = _char_selected.grid_position + start + board_block[end]
			_blocks_selectables.append(block)
	
	var slot = _card_selected.get_data().get("slot%s" % _slot_selected)
	_card_selected.slot_selected = _slot_selected
	
	for block in _blocks_selectables.duplicate():
		var match_found = false
		
		for char in get_tree().get_nodes_in_group("chars"):
			if char.grid_position == block:
				match_found = true
		
		if slot == 10: #MOVE
			if match_found:
				_blocks_selectables.erase(block)
		else:
			if not match_found:
				_blocks_selectables.erase(block)
	
	for block in get_tree().get_nodes_in_group("blocks"):
		var is_selectable = false
		for selectables in _blocks_selectables:
			if block.grid_position == selectables:
				is_selectable = true
		
		block.set_selectable(is_selectable,  slot)

func _reset_selectable_blocks() -> void:
	_blocks_selectables = []
	for block in get_tree().get_nodes_in_group("blocks"):
		block.set_selectable(false)

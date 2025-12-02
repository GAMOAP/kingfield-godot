extends Node

enum State { START_TURN, SELECT_ACTION, SELECT_BLOCK, RESOLVE_ACTION, END_TURN }

const board_block = [Vector2(0,0), Vector2(0,-1), Vector2(1,-1),
					Vector2(1,0), Vector2(1,1), Vector2(0,1), 
					Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1)]

var _char_selected = null
var _card_selected = null
var _block_selected = null
var _blocks_selectables = []

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
	_reset_selectable_blocks()
	EventManager.emit_unselect_all()

func _on_char_selected(char_id):
	if not active: return
	_char_selected = Global.char_selected
	_card_selected = null
	_reset_selectable_blocks()

func _on_card_selected(card):
	if not active or _char_selected == null: return
	_card_selected = Global.card_selected
	set_selectables_block()

func _on_block_selected(block_name):
	if not active: return
	_block_selected = Global.block_selected
	
	var resole_action = false
	for selectable in _blocks_selectables:
		if _block_selected.grid_position == selectable:
			resole_action = true
	
	var block_empty = true
	for char in get_tree().get_nodes_in_group("chars"):
		if char.grid_position == _block_selected.grid_position :
			block_empty = false
	
	if resole_action == true:
		_resolve_action()
	elif block_empty == true :
		_start_turn()

func _resolve_action():
	EventManager.emit_unselect_all()
	
	print("_resolve_action")
	#var block = get_node(block_id)
	#var target_pos = block.grid_position
	#
	#if Global.char_selected and Global.char_selected.team == Global.char_selected.TEAM.USER:
		#
		#if not is_block_occupied(target_pos):
			#Global.char_selected.move_to_cell(target_pos)
#
#func is_block_occupied(grid_pos: Vector2) -> bool:
	#for char in get_tree().get_nodes_in_group("chars"):
		#if char.grid_position == grid_pos:
			#return true
	#return false

func _end_turn():
	print("Fin du tour.")


func set_selectables_block(reset := false) -> void:
	_blocks_selectables = []
	
	if _char_selected == null or _card_selected == null: return
	
	_card_selected = Global.card_selected
	var board = _card_selected.get_data().get('board')
	if not board: return
	
	for path in board:
		var start := Vector2(path["start"][0], path["start"][1])
		var ends = path["end"]
		
		for end in ends:
			var block = _char_selected.grid_position + start + board_block[end]
			_blocks_selectables.append(block)
			
	for block in get_tree().get_nodes_in_group("blocks"):
		var is_selectable = false
		for selectables in _blocks_selectables:
			if block.grid_position == selectables:
				is_selectable = true
		
		block.set_selectable(is_selectable)

func _reset_selectable_blocks() -> void:
	_blocks_selectables = []
	for block in get_tree().get_nodes_in_group("blocks"):
		block.set_selectable(false)

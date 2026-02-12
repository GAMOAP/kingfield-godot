extends Node


const board_block = [Vector2(0,0), Vector2(0,-1), Vector2(1,-1),
					Vector2(1,0), Vector2(1,1), Vector2(0,1), 
					Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1)]



var _char_selected = null
var _card_selected = null
var _block_selected = null
var _blocks_selectables := []
var _slot_selected := 1
var _char_position_temp := Vector2(0, 0)
var _turn := 0
var _actions := []

var active = false

# ----------------------------
# INITIALISATION
# ----------------------------
func start_game():
	active = true
	EventManager.char_clicked.connect(_on_char_selected)
	EventManager.card_clicked.connect(_on_card_selected)
	EventManager.block_clicked.connect(_on_block_selected)
	#EventManager.turn_received.connect(_on_receive_turn)
	#EventManager.game_turn_end.connect(_on_end_turn)
	
	_start_turn()

func end_game():
	active = false
	EventManager.char_clicked.disconnect(_on_char_selected)
	EventManager.card_clicked.disconnect(_on_card_selected)
	EventManager.block_clicked.disconnect(_on_block_selected)
	#EventManager.game_turn_end.disconnect(_on_end_turn)

# ----------------------------
# START END
# ----------------------------
func _start_turn():
	if not active: return
	_char_selected = null
	_card_selected = null
	_slot_selected = 1
	_char_position_temp = Vector2(0, 0)
	_actions = []
	_reset_selectable_blocks()
	
	EventManager.emit_unselect_all()

func _on_end_turn():
	#var mana = _card_selected.get_data().get('mana')
	#_char_selected.consume_mana(mana)
	
	print("END_TURN")
	_start_turn()
	
# ----------------------------
# SELECT OBJECT
# ----------------------------
func _on_char_selected(char_id: String, team: Global.SIDE):
	if not active: return
	_char_selected = Global.char_selected
	_card_selected = null
	_slot_selected = 1
	_char_position_temp = Vector2(0, 0)
	_actions = []
	EventManager.emit_unselect_cards()
	_reset_selectable_blocks()

func _on_card_selected(card):
	if not active or _char_selected == null: return 
	_card_selected = Global.card_selected
	_reset_selectable_blocks()
	
	if _card_selected.is_playable == true: 
		_char_position_temp = Vector2(0, 0)
		_actions = []
		_set_selectables_block()

func _on_block_selected(block_name):
	if not active: return
	_block_selected = Global.block_selected
	
	var block_selectable = false
	for block_data in _blocks_selectables:
		if _block_selected.grid_position == block_data["block"]:
			if block_data["slot"] == 10: #MOVE
				_char_position_temp = block_data["board"]
			block_selectable = true
	
	var block_empty = true
	for char in get_tree().get_nodes_in_group("chars"):
		if char.grid_position == _block_selected.grid_position :
			if block_selectable == true:
				char.is_selectable = false
			block_empty = false

	if block_selectable == true:
		_resolve_slot()
		
	elif block_empty == true :
		_start_turn()
		
# ----------------------------
# RESOLVE
# ----------------------------
func _resolve_slot():
	var action_id = _card_selected.get_data().get("slot%s" % _slot_selected)
	var next_slot = _card_selected.get_data().get("slot%s" % (_slot_selected + 1))
	
	var action = {
			"char_name" = _char_selected.name,
			"card_id" = _card_selected.id,
			"block_label" = _block_selected.match_label,
			"action_id" = action_id
		}
	
	_actions.append(action)
	_slot_selected += 1
	
	if not next_slot:
		if MatchManager.current_match:
			ActionManager.is_game_unlocked = false
			print(_actions)
			ServerManager.send_turn({
				"turn" : _turn,
				"actions" : _actions
			})
			pass
		else:
			ActionManager.resolve_action(_actions)
	else:
		_set_selectables_block()





func _set_selectables_block() -> void:
	_blocks_selectables = []
	
	if _char_selected == null or _card_selected == null: return
	
	var board = _card_selected.get_data().get('board')
	if not board: return
	
	var slot = _card_selected.get_data().get("slot%s" % _slot_selected)
	_card_selected.slot_selected = _slot_selected
	
	for path in board:
		var start := Vector2(path["start"][0], path["start"][1])
		if start == _char_position_temp:
			var ends = path["end"]
			for end in ends:
				var data := {
					"block" : _char_selected.grid_position + start + board_block[end],
					"board" : start + board_block[end],
					"slot" : slot
				}
				_blocks_selectables.append(data)
	
	if _char_position_temp != Vector2(0,0):
		var data := {
			"block" : _char_selected.grid_position + _char_position_temp,
			"board" : _char_position_temp,
			"slot" : slot
		}
		_blocks_selectables.append(data)
	
	for block_data in _blocks_selectables.duplicate():
		var match_found = false
		
		for char in get_tree().get_nodes_in_group("chars"):
			if char.grid_position == block_data["block"]:
				match_found = true
		
		if slot == 10: #MOVE
			if match_found:
				_blocks_selectables.erase(block_data)
		else:
			if not match_found:
				_blocks_selectables.erase(block_data)
	
	for block in get_tree().get_nodes_in_group("blocks"):
		var is_selectable = false
		for block_data in _blocks_selectables:
			if block.grid_position == block_data["block"]:
				is_selectable = true
		
		block.set_selectable(is_selectable,  slot)

func _reset_selectable_blocks() -> void:
	_blocks_selectables = []
	for block in get_tree().get_nodes_in_group("blocks"):
		block.set_selectable(false)

func _on_receive_turn(data) -> void:
	print(data["actions"])
	var actions = data["actions"]
	
	ActionManager.resolve_action(actions)

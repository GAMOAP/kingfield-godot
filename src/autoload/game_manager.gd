extends Node

const board_block = [Vector2(0,0), Vector2(0,-1), Vector2(1,-1),
					Vector2(1,0), Vector2(1,1), Vector2(0,1), 
					Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1)]

var _unit_selected = null
var _card_selected = null
var _block_selected = null
var _blocks_selectables := []
var _slot_selected := 1
var _unit_position_temp := Vector2(0, 0)
var _actions := []

var active = false

# ----------------------------
# INITIALISATION
# ----------------------------
func start_game():
	active = true
	EventManager.unit_clicked.connect(_on_unit_selected)
	EventManager.card_clicked.connect(_on_card_selected)
	EventManager.block_clicked.connect(_on_block_selected)
	
	start_turn()

func end_game():
	active = false
	ActionManager.game_locked = false
	EventManager.unit_clicked.disconnect(_on_unit_selected)
	EventManager.card_clicked.disconnect(_on_card_selected)
	EventManager.block_clicked.disconnect(_on_block_selected)

# ----------------------------
# START/END
# ----------------------------
func start_turn():
	if not active: return
	_unit_selected = null
	_card_selected = null
	_slot_selected = 1
	_unit_position_temp = Vector2(0, 0)
	_actions = []
	_reset_selectable_blocks()
	
	EventManager.emit_unselect_all()
	ActionManager.game_locked = false

func end_turn():
	#var mana = _card_selected.get_data().get('mana')
	#_unit_selected.consume_mana(mana)
	
	print("END_TURN")
	start_turn()
	
# ----------------------------
# SELECT OBJECT
# ----------------------------
func _on_unit_selected(unit_id: String, team: Global.SIDE):
	if not active: return
	_unit_selected = Global.unit_selected
	_card_selected = null
	_slot_selected = 1
	_unit_position_temp = Vector2(0, 0)
	_actions = []
	EventManager.emit_unselect_cards()
	_reset_selectable_blocks()

func _on_card_selected(card):
	if not active or _unit_selected == null: return 
	_card_selected = Global.card_selected
	_reset_selectable_blocks()
	
	if _card_selected.is_playable == true: 
		_unit_position_temp = Vector2(0, 0)
		_actions = []
		_set_selectables_block()

func _on_block_selected(block_name):
	if not active: return
	_block_selected = Global.block_selected
	
	var block_selectable = false
	for block_data in _blocks_selectables:
		if _block_selected.grid_position == block_data["block"]:
			if block_data["slot"] == 10: #MOVE
				_unit_position_temp = block_data["board"]
			block_selectable = true
	
	var block_empty = true
	for unit in get_tree().get_nodes_in_group("units"):
		if unit.grid_position == _block_selected.grid_position :
			if block_selectable == true:
				unit.is_selectable = false
			block_empty = false

	if block_selectable == true:
		_resolve_slot()
		
	elif block_empty == true :
		start_turn()
		
# ----------------------------
# RESOLVE
# ----------------------------
func _resolve_slot():
	var action_id = _card_selected.get_data().get("slot%s" % _slot_selected)
	var next_slot = _card_selected.get_data().get("slot%s" % (_slot_selected + 1))
	
	var action = {
			"unit_name" = _unit_selected.name,
			"unit_camp" = _unit_selected.camp,
			"card_id" = _card_selected.id,
			"block_label" = _block_selected.match_label,
			"action_id" = action_id
		}
	
	_actions.append(action)
	_slot_selected += 1
	
	if not next_slot:
		ActionManager.game_locked = true
		#Match Scecne
		if MatchManager.current_match :
			MatchManager.send_turn(_actions)
		#Training Scene
		else:
			resolve_action(true, _actions)
	else:
		_set_selectables_block()

func resolve_action(resolve : bool, actions = {}) -> void :
	if resolve == true:
		ActionManager.resolve_action(actions)
	else :
		start_turn()

func _set_selectables_block() -> void:
	_blocks_selectables = []
	
	if _unit_selected == null or _card_selected == null: return
	
	var board = _card_selected.get_data().get('board')
	if not board: return
	
	var slot = _card_selected.get_data().get("slot%s" % _slot_selected)
	_card_selected.slot_selected = _slot_selected
	
	for path in board:
		var start := Vector2(path["start"][0], path["start"][1])
		if start == _unit_position_temp:
			var ends = path["end"]
			for end in ends:
				var data := {
					"block" : _unit_selected.grid_position + start + board_block[end],
					"board" : start + board_block[end],
					"slot" : slot
				}
				_blocks_selectables.append(data)
	
	if _unit_position_temp != Vector2(0,0):
		var data := {
			"block" : _unit_selected.grid_position + _unit_position_temp,
			"board" : _unit_position_temp,
			"slot" : slot
		}
		_blocks_selectables.append(data)
	
	for block_data in _blocks_selectables.duplicate():
		var match_found = false
		
		for unit in get_tree().get_nodes_in_group("units"):
			if unit.grid_position == block_data["block"]:
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
	_slot_selected = 1
	for block in get_tree().get_nodes_in_group("blocks"):
		block.set_selectable(false)

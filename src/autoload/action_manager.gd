extends Node

var _action_map = {}

var _is_game_unlocked = false:
	set = _set_game_unlocked

func resolve_action(actions) -> void:
	_is_game_unlocked = false
	
	for act in actions:
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
		await executor.execute(act)
	
	_is_game_unlocked = true
	EventManager.emit_game_turn_end()

func _set_game_unlocked(value):
	_is_game_unlocked = value
	
	EventManager.emit_unselect_all()
	
	for char in get_tree().get_nodes_in_group("chars"):
		char.is_selectable = _is_game_unlocked
	for block in get_tree().get_nodes_in_group("blocks"):
		block.is_selectable = _is_game_unlocked

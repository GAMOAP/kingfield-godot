extends Node

var _action_map = {}

var is_game_unlocked = false:
	set = _set_game_unlocked

func resolve_action(actions) -> void:
	is_game_unlocked = false
	
	print(actions)
	
	for act_temp in actions:
		
		var unit = null
		for unit_temp in get_tree().get_nodes_in_group("units"):
			if unit_temp.name == act_temp["unit_name"] and unit_temp.camp == act_temp["unit_camp"]:
				unit = unit_temp
		
		var block = null
		for block_temp in get_tree().get_nodes_in_group("blocks"):
			if block_temp.match_label == act_temp["block_label"]:
				block = block_temp
		
		var card_data = DataManager.get_card_data(act_temp["card_id"])
		var action_id = act_temp["action_id"]
		
		
		var action_type 
		for key in Global.SLOTS.keys():
			if Global.SLOTS[key] == action_id:
				action_type = key
		
		if not _action_map.has(action_type):
			var action_path = "res://src/actions/%s.gd" % action_type.to_lower()
			if FileAccess.file_exists(action_path):
				var action = load(action_path)
				if action:
					_action_map[action_type] = action.new()
		
		var act := {
			"unit" = unit,
			"card_data" = card_data,
			"block_pos" = block.grid_position,
		}
		
		
		var executor = _action_map[action_type]
		await executor.execute(act)
	
	is_game_unlocked = true
	EventManager.emit_game_turn_end()

func _set_game_unlocked(value):
	is_game_unlocked = value
	
	EventManager.emit_unselect_all()
	
	for unit in get_tree().get_nodes_in_group("units"):
		unit.is_selectable = is_game_unlocked
	for block in get_tree().get_nodes_in_group("blocks"):
		block.is_selectable = is_game_unlocked

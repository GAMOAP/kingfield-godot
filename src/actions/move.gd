extends Action

func _execute(action_data):
	var unit = action_data["unit"]
	var block_position = action_data["block_pos"]
	
	await unit.move_to_cell(block_position)
	
	print("➡️ MOVE:", unit.name, "→", block_position)

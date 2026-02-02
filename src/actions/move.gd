extends Action

func _execute(action_data):
	var char = action_data["char"]
	var block_position = action_data["block_pos"]
	
	await char.move_to_cell(block_position)
	
	print("➡️ MOVE:", char.name, "→", block_position)

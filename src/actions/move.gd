extends Action

func _execute(action_data):
	var char = action_data["char"]
	var block = action_data["block"]
	
	await char.move_to_cell(block.grid_position)
	
	#char.grid_position = block.grid_position
	#char.global_position = block.global_position
	
	print("➡️ MOVE:", char.name, "→", block.grid_position)

extends Action

func execute(action_data):
	var char = action_data["char"]
	var block = action_data["block"]
	
	char.grid_position = block.grid_position
	char.global_position = block.global_position
	
	print("➡️ MOVE:", char.name, "→", block.grid_position)

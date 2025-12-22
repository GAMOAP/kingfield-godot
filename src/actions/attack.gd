extends Action

func execute(action_data):
	var char = action_data["char"]
	var block = action_data["block"]
	
	for target in char.get_tree().get_nodes_in_group("chars"):
		if target.grid_position == block.grid_position:
			if target.has_method("take_damage"):
				target.take_damage(char.attack)
			print("⚔️ ATTACK:", char.name, "→", target.name)
			return

extends Action

func execute(action_data):
	var char = action_data["char"]
	if char.has_method("apply_sleep"):
		char.apply_sleep()
	
	print("💤 SLEEP:", char.name)

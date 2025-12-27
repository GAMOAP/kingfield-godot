extends Resource

class_name Action

func execute(action_data: Dictionary) -> void:
	await _execute(action_data)

func _execute(action_data: Dictionary) -> void:
	push_warning("execute() non implémenté dans " + str(self))

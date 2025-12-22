# Action.gd
extends Resource
class_name Action

func execute(action_data: Dictionary) -> void:
	# Action_data contient :
	# "char", "card", "block", "slot"
	push_warning("execute() non implémenté dans " + str(self))

extends Node2D


signal library_action(action)

func start() -> void:
	$background.visible = true

func stop() -> void:
	$background.visible = false


func _on_btn_close_pressed() -> void:
	library_action.emit("stop")

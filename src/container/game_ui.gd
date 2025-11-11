extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open() -> void:
	self.visible = true

func close() -> void:
	self.visible = false

func _on_match_btn_pressed() -> void:
	EventManager.emit_set_scene(Global.SCENES.MATCH)

func _on_training_btn_pressed() -> void:
	EventManager.emit_set_scene(Global.SCENES.TRAINING)

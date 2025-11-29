extends Node2D

var _scene: Global.SCENES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Exit_btn.visible = false
	EventManager.char_clicked.connect(_on_char_clicked)
	EventManager.deck_card_submit.connect(_on_deck_card_submit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open()-> void:
	_scene = Global.scene_selected
	
	$Exit_btn.visible = false
	match _scene:
		Global.SCENES.HOME :
			$Characters.init_team(Global.SIDE.USER)
			$Blocks.show_nbr_row(1)
			EventManager.emit_unselect_all()
		Global.SCENES.BARRACK :
			$Characters.init_team(Global.SIDE.USER)
			$Blocks.show_nbr_row(1)
		Global.SCENES.MATCH :
			pass
		Global.SCENES.TRAINING :
			$Characters.init_team(Global.SIDE.USER)
			$Blocks.show_nbr_row(5)
			$Exit_btn.visible = true
			EventManager.emit_unselect_all()
		_:
			pass
	
	set_blocks_karma()

func close()-> void:
	pass

func _on_char_clicked(name: String):
	if _scene == Global.SCENES.HOME:
		EventManager.emit_set_scene(Global.SCENES.BARRACK)

func _on_deck_card_submit(card_id: String) -> void:
	set_blocks_karma()

func set_blocks_karma() -> void:
	var karma: int= $Characters.get_team_karma(Global.SIDE.USER)
	$Blocks.set_block_karma(karma)

func _on_exit_btn_pressed() -> void:
	EventManager.emit_set_scene(Global.SCENES.HOME)

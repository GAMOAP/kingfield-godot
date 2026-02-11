extends Node2D

var _scene: Global.SCENES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Exit_btn.visible = false
	EventManager.char_clicked.connect(_on_char_clicked)
	EventManager.deck_card_submit.connect(_on_deck_card_submit)
	EventManager.player_left.connect(_on_player_left)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open()-> void:
	_scene = Global.scene_selected
	
	$Exit_btn.visible = false
	$Characters.remove_team(Global.SIDE.OPPONENT)
	match _scene:
		Global.SCENES.HOME :
			$Characters.init_team(Global.SIDE.USER)
			$Blocks.show_nbr_row(1)
			EventManager.emit_unselect_all()
		Global.SCENES.BARRACK :
			$Characters.init_team(Global.SIDE.USER)
			$Blocks.show_nbr_row(1)
		Global.SCENES.LOBBY :
			$Characters.init_team(Global.SIDE.USER)
			$Blocks.show_nbr_row(1)
			EventManager.emit_unselect_all()
		Global.SCENES.MATCH :
			$Characters.init_team(Global.SIDE.USER)
			$Characters.init_team(Global.SIDE.OPPONENT)
			$Blocks.show_nbr_row(5)
			$Exit_btn.visible = true
			EventManager.emit_unselect_all()
		Global.SCENES.TRAINING :
			$Characters.init_team(Global.SIDE.USER)
			$Blocks.show_nbr_row(5)
			$Exit_btn.visible = true
			EventManager.emit_unselect_all()
		_:
			pass
	
	_set_blocks()

func close()-> void:
	pass

func _on_char_clicked(name: String, team: Global.SIDE):
	if _scene == Global.SCENES.HOME:
		EventManager.emit_set_scene(Global.SCENES.BARRACK)

func _on_deck_card_submit(card_id: String) -> void:
	_set_blocks()

func _set_blocks() -> void:
	$Blocks.set_blocks($Characters.get_team_karma(Global.SIDE.USER))

func _on_exit_btn_pressed() -> void:
	_left_match()

func _on_player_left() -> void:
	_left_match()

func _left_match() -> void:
	if _scene == Global.SCENES.MATCH:
		MatchManager.end_match()
	if _scene == Global.SCENES.TRAINING:
		EventManager.emit_set_scene(Global.SCENES.HOME)

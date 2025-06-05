extends Node2D

enum SCENES {HOME, LYBRARY, MATCH}
var _scene := SCENES.HOME

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.multi_UI_action.connect(_on_multi_UI_action)
	EventManager.library_action.connect(_on_library_action)
	EventManager.char_clicked.connect(_on_char_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_multi_UI_action(UI_action, data :={}) -> void :
	print("=============UI_Action ===========%s" % UI_action)
	match UI_action:
		"user_connected" :
			$Logo.visible = false
			$Characters.init_team(Global.SIDE.USER)
			$Blocks_field.show_block_row(4)
		"match_found" :
			$Characters.init_team(Global.SIDE.OPPONENT, data["opponent_data"]["user_id"])

func _on_char_selected(char_id, team, data):
	if _scene == SCENES.HOME:
		$Library.open()
		$MultiplayerUI.stop()
		_scene = SCENES.LYBRARY

func _on_library_action(action) -> void:
	if _scene == SCENES.LYBRARY:
		$Library.stop()
		$MultiplayerUI.start()
		$Characters.unselect_all()
		_scene = SCENES.HOME

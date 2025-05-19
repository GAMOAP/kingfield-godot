extends Node2D

enum SCENES {HOME, LYBRARY, MATCH}
var _scene := SCENES.HOME

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MultiplayerUI.multi_UI_action.connect(_on_multi_UI_action)
	$Library.library_action.connect(_on_library_action)
	$Characters.char_selected.connect(_on_char_selected)

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

func _on_char_selected(char_id):
	print(char_id)
	if _scene == SCENES.HOME:
		$Library.start()
		$MultiplayerUI.stop()
		_scene = SCENES.LYBRARY

func _on_library_action(action) -> void:
	if _scene == SCENES.LYBRARY:
		$Library.stop()
		$MultiplayerUI.start()
		$Characters.unselect_all()
		_scene = SCENES.HOME

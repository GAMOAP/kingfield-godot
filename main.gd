extends Node2D


var _scene: Global.SCENES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect global events to local handler functions
	EventManager.multi_UI_action.connect(_on_multi_UI_action)
	EventManager.char_clicked.connect(_on_char_selected)
	EventManager.set_scene.connect(_on_set_scene)
	
	# Start the game on the CONNECTION scene
	_on_set_scene(Global.SCENES.CONNECTION)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Handles scene changes and updates the UI depending on the current scene
func _on_set_scene(scene: Global.SCENES) -> void:
	_scene = scene
	match scene:
		Global.SCENES.CONNECTION :
			$MultiplayerUI.connexion()
		Global.SCENES.HOME :
			$Logo.visible = false
			$Board/Characters.init_team(Global.SIDE.USER)
			$Board/Blocks_field.show_block_row(4)
			$MultiplayerUI.open()
			$Deck.close()
			$Library.close()
		Global.SCENES.SETTINGS :
			pass
		Global.SCENES.LYBRARY :
			$MultiplayerUI.close()
			$Deck.open()
			$Library.open()
		Global.SCENES.MATCH :
			pass

func _on_multi_UI_action(UI_action, data :={}) -> void :
	print("=== UI_Action : DEBUG === %s" % UI_action)
	match UI_action:
		"user_connected" :
			$Logo.visible = false
			$Board/Characters.init_team(Global.SIDE.USER)
			$Board/Blocks_field.show_block_row(4)
		"match_found" :
			$Board/Characters.init_team(Global.SIDE.OPPONENT, data["opponent_data"]["user_id"])

func _on_char_selected(char_id, team, data):
	if _scene == Global.SCENES.HOME:
		_on_set_scene(Global.SCENES.LYBRARY)

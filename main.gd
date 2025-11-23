extends Node2D


var _scene: Global.SCENES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.set_scene.connect(_on_set_scene)
	_on_set_scene(Global.SCENES.CONNECTION)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Handles scene changes and updates the UI depending on the current scene
func _on_set_scene(scene: Global.SCENES) -> void:
	Global.scene_selected = scene
	_scene = scene
	
	var connexion = false
	var game_ui = false
	var board = false
	var deck = false
	var library = false
	var players = false
	
	match _scene:
		Global.SCENES.CONNECTION :
			connexion = true
		Global.SCENES.HOME :
			game_ui = true
			players = true
			board = true
		Global.SCENES.SETTINGS :
			players = true
		Global.SCENES.BARRACK :
			board = true
			library = true
			deck = true
		Global.SCENES.MATCH :
			players = true
			board = true
			#deck = true
		Global.SCENES.TRAINING :
			players = true
			board = true
			deck = true
	
	if connexion == true:
		$Connexion.open()
	else :
		$Connexion.close()
	
	if game_ui == true:
		$Game_ui.open()
	else :
		$Game_ui.close()
	
	if board == true:
		$Board.open()
	else :
		$Board.close()
	
	if library == true:
		$Library.open()
	else :
		$Library.close()
	
	if deck == true:
		$Deck.open()
	else :
		$Deck.close()
	
	if players == true:
		pass
	else :
		pass

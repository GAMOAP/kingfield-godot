extends Node2D

var _scene: Global.SCENES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	EventManager.char_clicked.connect(_on_char_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open(scene: Global.SCENES)-> void:
	$Blocks.set_block_karma(_get_team_karma())
	
	_scene = scene
	match _scene:
		Global.SCENES.HOME :
			$Characters.init_team(Global.SIDE.USER)
			$Characters.unselect_all()
			$Blocks.show_nbr_row(1)
		Global.SCENES.BARRACK :
			$Characters.init_team(Global.SIDE.USER)
			$Blocks.show_nbr_row(1)
		Global.SCENES.MATCH :
			pass
		Global.SCENES.TRAINING :
			$Characters.init_team(Global.SIDE.USER)
			$Blocks.show_nbr_row(5)
		_:
			pass

func close()-> void:
	pass

func _on_char_clicked(name: String):
	if _scene == Global.SCENES.HOME:
		EventManager.emit_set_scene(Global.SCENES.BARRACK)

func _get_team_karma() -> int:
	var karma: int= $Characters.get_team_karma(Global.SIDE.USER)
	return karma

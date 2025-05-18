extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MultiplayerUI.multi_UI_action.connect(_on_multi_UI_action)

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

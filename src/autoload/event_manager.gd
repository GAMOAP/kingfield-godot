extends Node

signal match_found(match_data: Dictionary)
signal turn_received(turn_data: Dictionary)

signal multi_UI_action(message: String, data: Dictionary)

signal char_clicked(char_name: String, char_team: int, data: Dictionary)

signal card_clicked(card_id: String, container: Global.CONTAINER)

signal admin_card_subit(card_id: String)

signal deck_card_submit(char_name: String, card_id: String)

signal set_scene(scene: Global.SCENES)



# ----------------------------
#  MULTIPLAYER ACTION
# ----------------------------
func emit_match_found(match_data: Dictionary) -> void:
	match_found.emit(match_data)

func emit_turn_received(turn_data: Dictionary) -> void:
	turn_received.emit(turn_data)

# ----------------------------
#  SCENE
# ----------------------------
func emit_set_scene(scene: Global.SCENES) -> void:
	set_scene.emit(scene)

# ----------------------------
#  OBJECT CLICKED
# ----------------------------
func emit_char_clicked(name: String, team: int, data := {}) -> void:
	char_clicked.emit(name, team, data)

func emit_card_clicked(card_id: String, container: Global.CONTAINER) -> void:
	card_clicked.emit(card_id, container)

# ----------------------------
#  CHANGE USER DATA
# ----------------------------
func emit_deck_card_submit(name: String, card_id: String) -> void:
	deck_card_submit.emit(name, card_id)

# ----------------------------
#  ADMIN
# ----------------------------
func emit_admin_card_submit(card_id) -> void:
	admin_card_subit.emit(card_id)

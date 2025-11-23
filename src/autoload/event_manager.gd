extends Node

#  MULTIPLAYER ACTION
signal match_found(match_data: Dictionary)
signal turn_received(turn_data: Dictionary)

#  SCENE
signal set_scene(scene: Global.SCENES)

#  OBJECT CLICKED
signal char_clicked(char_name: String)
signal card_clicked(card_id: String)
signal block_clicked(block_id: String)

#  UI CLICKED
signal library_page_change(page: int)

#  CHANGE USER DATA
signal deck_card_submit(card_id: String)

#  ADMIN
signal admin_card_subit(card_id: String)


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
func emit_char_clicked(name: String) -> void:
	char_clicked.emit(name)

func emit_card_clicked(card_id: String) -> void:
	card_clicked.emit(card_id)

func emit_block_clicked(block_id: String) -> void:
	block_clicked.emit(block_id)

# ----------------------------
#  UI CLICKED
# ----------------------------
func emit_library_page_change(page: int) -> void:
	library_page_change.emit(page)

# ----------------------------
#  CHANGE USER DATA
# ----------------------------
func emit_deck_card_submit(card_id: String) -> void:
	deck_card_submit.emit(card_id)

# ----------------------------
#  ADMIN
# ----------------------------
func emit_admin_card_submit(card_id) -> void:
	admin_card_subit.emit(card_id)

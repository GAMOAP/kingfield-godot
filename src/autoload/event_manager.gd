extends Node

# GAME ACTION
signal game_turn_end()

# SCENE
signal set_scene(scene: Global.SCENES)

# OBJECT CLICKED
signal char_clicked(char_name: String, char_team: Global.SIDE)
signal card_clicked(card_id: String)
signal block_clicked(block_id: String)

# OBJECT UNSELECT
signal unselect_chars()
signal unselect_cards()
signal unselect_blocks()

# ELEMENT SELECTED
signal select_slot(slot_nbr: int)

# UI CLICKED
signal library_page_change(page: int)

# CHANGE USER DATA
signal deck_card_submit(card_id: String)

# ADMIN
signal admin_card_subit(card_id: String)

# MATCH
signal match_found(match_data)
signal game_start(game_data)
signal player_joined(player_data)
signal player_left(player_data)


# ----------------------------
#  GAME ACTION
# ----------------------------
func emit_game_turn_end() -> void:
	game_turn_end.emit()

# ----------------------------
#  SCENE
# ----------------------------
func emit_set_scene(scene: Global.SCENES) -> void:
	set_scene.emit(scene)

# ----------------------------
#  OBJECT CLICKED
# ----------------------------
func emit_char_clicked(name: String, team: Global.SIDE) -> void:
	char_clicked.emit(name, team)

func emit_card_clicked(card_id: String) -> void:
	card_clicked.emit(card_id)

func emit_block_clicked(block_id: String) -> void:
	block_clicked.emit(block_id)


func emit_unselect_all() -> void:
	unselect_chars.emit()
	unselect_cards.emit()
	unselect_blocks.emit()

func emit_unselect_cards() -> void:
	unselect_cards.emit()

func emit_unselect_chars() -> void:
	unselect_chars.emit()

func emit_unselect_bloks() -> void:
	unselect_blocks.emit()

func emit_select_slot(slot_nbr :int = 0) -> void:
	select_slot.emit(slot_nbr)

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

# ----------------------------
#  MULTIPLAYER ACTION
# ----------------------------
func emit_match_found(match_data: Dictionary) -> void:
	match_found.emit(match_data)

func emit_game_start(game_data: Dictionary) -> void:
	game_start.emit(game_data)

func emit_player_joined(player_data: Dictionary) -> void:
	player_joined.emit(player_data)

func emit_player_left(player_data: Dictionary) -> void:
	player_left.emit(player_data)

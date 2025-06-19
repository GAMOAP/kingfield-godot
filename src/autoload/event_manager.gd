extends Node

signal match_found(match_data: Dictionary)
signal turn_received(turn_data: Dictionary)

signal multi_UI_action(message: String, data: Dictionary)

signal library_action(message: String)


signal char_clicked(char_name: String, char_team: int, data: Dictionary)

signal card_clicked(card_id: String)

signal admin_card_subit(card_id: String)


func emit_match_found(match_data: Dictionary) -> void:
	match_found.emit(match_data)

func emit_turn_received(turn_data: Dictionary) -> void:
	turn_received.emit(turn_data)


func emit_multi_UI_action(message: String, data := {}) -> void:
	multi_UI_action.emit(message, data)

func emit_library(message: String) -> void:
	library_action.emit(message)


func emit_char_clicked(name: String, team: int, data := {}) -> void:
	char_clicked.emit(name, team, data)

func emit_card_clicked(card_id) -> void:
	card_clicked.emit(card_id)

func emit_admin_card_submit(card_id) -> void:
	admin_card_subit.emit(card_id)

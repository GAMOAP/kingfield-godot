extends Node2D

var username = ""
var _last_valid_text := ""

func _on_username_text_changed(new_text: String) -> void:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9]{0,12}$")  # Allow up to 12 letters or numbers
	
	if regex.search(new_text):
		_last_valid_text = new_text
		$login_menu/Panel/UsernameInput.add_theme_color_override("font_color", Color.WHITE)
	else:
		$login_menu/Panel/UsernameInput.text = _last_valid_text
		$login_menu/Panel/UsernameInput.add_theme_color_override("font_color", Color.RED)


func _on_username_input_text_submitted(input_text: String) -> void:
	validate_username(input_text)

func _on_confirm_button_down() -> void:
	var input_text = $login_menu/Panel/UsernameInput.text.strip_edges()  # Get the username without spaces
	validate_username(input_text)

func validate_username(input_text: String) -> void:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9]{6,12}$")  # Min 6, max 12, alphanumerics only
	
	if not regex.search(input_text):
		$login_menu/Panel/UsernameInput.add_theme_color_override("font_color", Color.RED)
	else:
		username = input_text
		var result = await ServerConnection.authenticate_async()
		if result == OK:
			connect_to_server()
		else:
			$login_menu/Panel/FeedbackLabel.text = result

func connect_to_server() -> void:
	print ("connected !!!")
	pass

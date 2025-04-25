extends Node2D

signal multi_UI_action(message: String)

var _userdata := {}
var _last_valid_text := ""

func _ready() -> void:
	var result = await ServerConnection.authenticate_async()
	if result == OK:
		$ConnexionPanel/SubmitButton.disabled = false
		if not ServerConnection.is_new_session():
			_userdata = await ServerConnection.get_user_account_async()
			$ConnexionPanel/UsernameInput.text = _userdata.username
			$ConnexionPanel/SubmitButton.text =  "Login"

func _on_username_input_text_changed(new_text: String) -> void:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9]{0,16}$")  # Allow up to 12 letters or numbers
	
	if regex.search(new_text):
		_last_valid_text = new_text
		$ConnexionPanel/UsernameInput.add_theme_color_override("font_color", Color.WHITE)
	else:
		$ConnexionPanel/UsernameInput.text = _last_valid_text
		$ConnexionPanel/UsernameInput.add_theme_color_override("font_color", Color.RED)

func _on_username_input_text_submitted(input_text: String) -> void:
	validate_username(input_text)

func _on_submit_button_button_down() -> void:
	var input_text = $ConnexionPanel/UsernameInput.text.strip_edges()  # Get the username without spaces
	validate_username(input_text)

func validate_username(input_text: String) -> void:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9]{6,16}$")  # Min 6, max 12, alphanumerics only
	
	if not regex.search(input_text):
		$ConnexionPanel/UsernameInput.add_theme_color_override("font_color", Color.RED)
	else:
		user_connected(input_text)

func user_connected(username) -> void:
	if _userdata.username != username:
			_userdata.username = username
			ServerConnection.update_user_account_async(username)
	
	$ConnexionPanel.visible = false
	$UserPanel.visible = true
	$UserPanel/UserName.text = username
	
	$ButtonStart.visible = true
	
	multi_UI_action.emit("user_connected")

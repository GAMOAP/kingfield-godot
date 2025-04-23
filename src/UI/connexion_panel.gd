extends Panel

var _username := ""
var _last_valid_text := ""

func _ready() -> void:
	var result = await ServerConnection.authenticate_async()
	if result == OK:
		get_user_name()

func _on_username_input_text_changed(new_text: String) -> void:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9]{0,12}$")  # Allow up to 12 letters or numbers
	
	if regex.search(new_text):
		_last_valid_text = new_text
		$UsernameInput.add_theme_color_override("font_color", Color.WHITE)
	else:
		$UsernameInput.text = _last_valid_text
		$UsernameInput.add_theme_color_override("font_color", Color.RED)


func _on_username_input_text_submitted(input_text: String) -> void:
	validate_username(input_text)

func _on_submit_button_button_down() -> void:
	var input_text = $UsernameInput.text.strip_edges()  # Get the username without spaces
	validate_username(input_text)

func validate_username(input_text: String) -> void:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9]{6,12}$")  # Min 6, max 12, alphanumerics only
	
	if not regex.search(input_text):
		$UsernameInput.add_theme_color_override("font_color", Color.RED)
	else:
		ServerConnection.update_user_account_async(_last_valid_text)

func get_user_name() -> void:
	var userdata = await ServerConnection.get_user_account_async()
	$UsernameInput.text = userdata.username
	
func set_user_name() -> void:
	var userdata = await ServerConnection.get_user_account_async()
	_last_valid_text = userdata.username

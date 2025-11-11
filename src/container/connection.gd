extends Node2D


var _userdata := {}
var _last_valid_text := ""

func _ready() -> void:
	$ConnexionPanel/PasswordInput.visible = false

func open() -> void:
	self.visible = true
	connexion()

func close() -> void:
	self.visible = false

# ----------------------------
# SERVER CONNECTION
# ----------------------------
func connexion() -> void:
	$ConnexionPanel.visible = true
	
	var result = await ServerManager.authenticate_async()
	if result != "ERROR":
		_userdata = await ServerManager.get_user_account_async()
		if result != "NEW_SESSION":
			$ConnexionPanel/UsernameInput.text = _userdata.username
			$ConnexionPanel/SubmitButton.text =  "Login"
		UserData.get_user_data()
		$ConnexionPanel.visible = true

# ----------------------------
# USERNAME VALIDATION
# ----------------------------
func _on_username_input_text_changed(new_text: String) -> void:
	if $ConnexionPanel/UsernameInput.text != "admin":
		$ConnexionPanel/PasswordInput.text = ""
		$ConnexionPanel/PasswordInput.visible = false
		
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

func _on_password_input_text_submitted(new_text: String) -> void:
	var input_text = $ConnexionPanel/UsernameInput.text.strip_edges()  # Get the username without spaces
	validate_username(input_text)

func _on_submit_button_button_down() -> void:
	var input_text = $ConnexionPanel/UsernameInput.text.strip_edges()  # Get the username without spaces
	validate_username(input_text)

func validate_username(input_text: String) -> void:
	if input_text == "admin":
		admin_connection()
	else:
		var regex = RegEx.new()
		regex.compile("^[a-zA-Z0-9]{6,16}$")  # Min 6, max 12, alphanumerics only
		if not regex.search(input_text):
			$ConnexionPanel/UsernameInput.add_theme_color_override("font_color", Color.RED)
		else:
			user_connected(input_text)

# ----------------------------
# ADMIN CONNECTION
# ----------------------------
func admin_connection() -> void:
	if $ConnexionPanel/PasswordInput.text != "":
		var password: String = $ConnexionPanel/PasswordInput.text
		var username: String = "admin"
		var result = await ServerManager.authenticate_admin_async(username, password)
		if result != "ERROR":
			_userdata = await ServerManager.get_user_account_async()
			user_connected(username)
			UserData.is_admin = true
	else:
		$ConnexionPanel/PasswordInput.visible = true

# ----------------------------
# USER CONNECTED
# ----------------------------
func user_connected(username) -> void:
	print("USERT CONNECTED")
	if _userdata.username != username :
		_userdata.username = username
		ServerManager.update_user_account_async(username)
	
	EventManager.emit_set_scene(Global.SCENES.HOME)

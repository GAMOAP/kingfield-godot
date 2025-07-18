extends Node2D


var _userdata := {}
var _last_valid_text := ""

func _ready() -> void:
	$ButtonStartFight.visible = false
	$ConnexionPanel.visible = false
	$ConnexionPanel/PasswordInput.visible = false
	$UserPanel.visible = false
	$OpponentPanel.visible = false
	$SendTurn.visible = false

# ----------------------------
# SERVER CONNECTION
# ----------------------------
func connexion() -> void:
	$ConnexionPanel.visible = true
	EventManager.match_found.connect(_on_match_found)
	EventManager.turn_received.connect(_on_receive_data)
	
	var result = await ServerManagement.authenticate_async()
	if result != "ERROR":
		_userdata = await ServerManagement.get_user_account_async()
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
		var result = await ServerManagement.authenticate_admin_async(username, password)
		if result != "ERROR":
			_userdata = await ServerManagement.get_user_account_async()
			user_connected(username)
			UserData.is_admin = true
	else:
		$ConnexionPanel/PasswordInput.visible = true

# ----------------------------
# USER CONNECTED
# ----------------------------
func user_connected(username) -> void:
	if _userdata.username != username :
		_userdata.username = username
		ServerManagement.update_user_account_async(username)
	
	$ConnexionPanel.visible = false
	$UserPanel.visible = true
	$UserPanel/UserName.text = username
	
	$ButtonStartFight.visible = true
	
	EventManager.emit_set_scene(Global.SCENES.HOME)

# ----------------------------
# START FIGHT
# ----------------------------
func _on_button_start_fight_pressed() -> void:
	var result = await ServerManagement.connect_to_server_async()
	if result == OK :
		$ButtonStartFight.visible = false
		ServerManagement.start_matchmaking()

func _on_match_found(match_data):
	$SendTurn.visible = true
	$OpponentPanel.visible = true
	$OpponentPanel/OpponentName.add_theme_color_override("font_color", Color.RED)
	$OpponentPanel/OpponentName.text = match_data["opponent_data"]["username"]
	
	EventManager.emit_set_scene(Global.SCENES.MATCH)

# ----------------------------
# SEND/RECEIVE DATA
# ----------------------------
func _on_send_data_button_pressed() -> void:
	var new_data = $SendTurn/Data.text
	var data : Dictionary = {
		"data": new_data
	}
	ServerManagement.send_turn(data)

func _on_receive_data(turn_data : Dictionary) -> void:
	$SendTurn/ReceivedData. text = turn_data.data
	
# ----------------------------
# STOP
# ----------------------------
func open() -> void:
	$ButtonStartFight.visible = true

func close() -> void:
	$ButtonStartFight.visible = false

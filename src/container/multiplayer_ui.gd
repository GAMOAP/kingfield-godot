extends Node2D

signal multi_UI_action(message: String, data: Dictionary)

var _userdata := {}
var _last_valid_text := ""

# ----------------------------
# SERVER CONNECTION
# ----------------------------
func _ready() -> void:
	ServerManagement.match_found.connect(_on_match_found)
	ServerManagement.turn_received.connect(_on_receive_data)
	
	var result = await ServerManagement.authenticate_async()
	if result != "ERROR":
		_userdata = await ServerManagement.get_user_account_async()
		if result != "NEW_SESSION":
			$ConnexionPanel/UsernameInput.text = _userdata.username
			$ConnexionPanel/SubmitButton.text =  "Login"
		$ConnexionPanel.visible = true

# ----------------------------
# USERNAME VALIDATION
# ----------------------------
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
	
	multi_UI_action.emit("user_connected")

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
	
	multi_UI_action.emit("match_found", match_data)

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
	

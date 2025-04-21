extends Node2D

var _email = ""
var _password = ""
var _password_confim = ""
var _panel = "Sign up"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_confirm_button_down() -> void:
	_email = $login_menu/Panel/email.text
	_password = $login_menu/Panel/password.text
	if _panel == "Sign up":
		_password_confim = $login_menu/Panel/password_confirm.text
	
	elif _panel == "Login":
		pass
	


func _on_change_panel_button_down() -> void:
	print(_panel)
	if _panel == "Sign up":
		$login_menu/Panel/password_confirm.visible = false
		$login_menu/Panel/change_panel.text = "Sign up"
		$login_menu/Panel/confirm.text = "Login"
		_panel = "Login"
	
	elif _panel == "Login":
		$login_menu/Panel/password_confirm.visible = true
		$login_menu/Panel/change_panel.text = "Login"
		$login_menu/Panel/confirm.text = "Sign up"
		_panel = "Sign up"

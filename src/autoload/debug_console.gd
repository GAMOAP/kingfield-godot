extends Node

@onready var console := get_node("/root/Main/DebugConsole")

enum LogLevel { INFO, WARNING, ERROR }

func log(message: String, level: LogLevel = LogLevel.INFO) -> void:
	var level_name := get_level_name(level)
	var color := get_level_color(level)
	
	var formatted = "[color=%s][%s] %s[/color]\n" % [color, level_name, message]
	if console:
		console.append_text(formatted)

func get_level_name(level: LogLevel) -> String:
	match level:
		LogLevel.INFO:
			return "Info"
		LogLevel.WARNING:
			return "Warning"
		LogLevel.ERROR:
			return "Error"
		_:
			return "Log"

func get_level_color(level: LogLevel) -> String:
	match level:
		LogLevel.INFO:
			return "white"
		LogLevel.WARNING:
			return "orange"
		LogLevel.ERROR:
			return "red"
		_:
			return "gray"

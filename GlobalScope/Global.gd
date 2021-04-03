extends Node

onready var root =  get_tree().get_current_scene()
var screen_metrics_dict = {}
var camera:Camera2D
var camera_zoom = Vector2.ZERO

func _ready():
	screen_metrics()

func screen_metrics():
	screen_metrics_dict["Display"] = OS.get_screen_size()
	screen_metrics_dict["Decorated Window size"] = OS.get_real_window_size()
	screen_metrics_dict["Window_size"] = OS.get_window_size()
	if OS.is_debug_build():
		print("                 Screen Metrics")
		print("            Display size: ", OS.get_screen_size())
		print("   Decorated Window size: ", OS.get_real_window_size())
		print("             Window size: ", OS.get_window_size())
		print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 





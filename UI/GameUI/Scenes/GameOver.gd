extends Control

signal reset_game()

func _ready():
# warning-ignore:return_value_discarded
	connect("reset_game",Global,"reload_world_gloabally")

func initGameOver():
	visible = !visible

func _on_Exit_pressed():
	get_tree().quit()


func _on_Restart_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	emit_signal("reset_game")
	get_tree().paused = false



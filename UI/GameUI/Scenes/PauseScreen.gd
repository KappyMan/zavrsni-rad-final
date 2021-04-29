extends Control

func invertVisibility():
	visible = ! visible
	get_tree().paused = visible

func _on_ResumeButton_pressed():
	get_tree().paused = false
	visible = !visible

func _on_CloseButton_pressed():
	get_tree().paused = false
	visible = !visible


func _on_ExitButton_pressed():
	get_tree().quit()

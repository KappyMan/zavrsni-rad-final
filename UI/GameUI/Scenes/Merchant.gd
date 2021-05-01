extends Control

onready var orbit = $Orbit
onready var tween = $Tween
onready var purple = $Purple

func _ready():
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()



func _on_Tween_tween_all_completed():
	purple.emitting = true
	orbit.emitting = true

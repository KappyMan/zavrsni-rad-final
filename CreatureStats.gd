extends Node

signal health_updated(health)
signal killed()

export(int) var max_health = 3

onready var invulnerability_timer = $Timer
onready var health = max_health setget _set_health
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_health(health - amount)

func kill():
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

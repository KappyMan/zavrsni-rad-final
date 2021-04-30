extends Node

signal health_updated(health)
#signal shield_updated(shield)
signal killed()

export(int) var max_health = 3
 
onready var invulnerability_timer = $Timer
onready var health = max_health setget _set_health, _get_health

var shield:bool = false setget _set_shield, _get_shield
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_health(health/2)
# warning-ignore:return_value_discarded
	connect("health_updated",get_parent(),"healthbarUpdate")

func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_shield(false)
		_set_health(health + shield - amount)


func kill():
	get_parent().queue_free()

func _set_shield(value):
	shield = value

func healthChange(healing_amount):
	var new_health_amount = _get_health() + healing_amount
	_set_health(new_health_amount)

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	print(health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

func _get_shield():
	return shield

func _get_health():
	return health

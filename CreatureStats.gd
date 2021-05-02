extends Node

signal health_updated(health)
signal shield_updated(shield)
signal killed(loser, winner)

export(int) var max_health = 10 
 
onready var invulnerability_timer = $Timer
onready var health = max_health setget _set_health, _get_health

var shield:bool = false setget _set_shield, _get_shield
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_health(max_health)
	if get_parent() is Sprite:
	# warning-ignore:return_value_discarded
		connect("health_updated",get_parent(),"healthbarUpdate")
	# warning-ignore:return_value_discarded
		connect("shield_updated",get_parent(),"shieldUpdate")
	# warning-ignore:return_value_discarded
		connect("killed",Global, "combat_finished")

func _set_shield(value):
	emit_signal("shield_updated", value)
	shield = value

func healthChange(healing_amount):
	var new_health_amount = _get_health() + int(_get_shield()) + healing_amount
	_set_shield(0)
	_set_health(new_health_amount)

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			if get_parent() is Sprite:
				emit_signal("killed", get_parent().rival)
				

func _get_shield():
	emit_signal("shield_updated", shield)
	return shield

func _get_health():
	return health

extends Node2D

const aggressiveCreature = preload("res://World/NPC/NPCs/AgressiveCreature.tscn")

var _timer = null

func _ready():
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	randomize()
	_timer.set_wait_time(rand_range(1,10))
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func _on_Timer_timeout():
	var path = get_parent().get_child(0).get_simple_path(get_parent().get_node("Homes").global_position,global_position)
	spawnCreature(path)
	randomize()
	_timer.set_wait_time(rand_range(1,10))

func spawnCreature(new_path):
	var aggressivecreature = aggressiveCreature.instance()
	get_parent().add_child(aggressivecreature)
	aggressivecreature.global_position=global_position
	aggressivecreature.path = new_path
	aggressivecreature.createCharacter("zombie", 1, 1)



extends Node2D

const createCreature = preload("res://World/NPC/NPCs/SmallCreatureCreator.tscn")
const aggressiveCreature = preload("res://World/NPC/NPCs/AgressiveCreature.tscn")
const ENEMY_CAP = 10

onready var creator = createCreature.instance()
onready var holder = get_parent().get_node("Enemies")
onready var goal = get_parent().get_node("Homes")

var enemy_count = []
var allow_spawn = true
var _timer = null

func _ready():
	add_child(creator)
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	randomize()
	_timer.set_wait_time(rand_range(1,10))
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func _process(_delta):
	enforceEnemyCap(enemy_count)

func _on_Timer_timeout():
	if allow_spawn:
		var path = get_parent().get_child(0).get_simple_path(goal.global_position,global_position)
		enemy_count.append(spawnCreature(path))
		print(enemy_count)
		randomize()
		_timer.set_wait_time(rand_range(1,1))

func spawnCreature(new_path):
	var aggressivecreature = aggressiveCreature.instance()
	aggressivecreature.global_position=global_position
	aggressivecreature.path = new_path
	holder.add_child(aggressivecreature)
	aggressivecreature.createCharacter(creator.getTextureForCreature("zombie",1,1))
	return aggressivecreature

func enforceEnemyCap(enemy_array):
	for enemy in enemy_array:
		if (!is_instance_valid(enemy)):
			enemy_array.erase(enemy)
	allow_spawn = (enemy_array.size() < ENEMY_CAP)

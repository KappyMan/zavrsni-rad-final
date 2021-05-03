extends Node2D

export(int) var SPAWNER_TIME = 60

const ENEMY_NAMES = ["zombie","spider", "sorcerer"]
const createCreature = preload("res://World/NPC/NPCs/SmallCreatureCreator.tscn")
const aggressiveCreature = preload("res://World/NPC/NPCs/AgressiveCreature.tscn")
const ENEMY_CAP = 10

onready var creator = createCreature.instance()
onready var holder = get_parent().get_node("Enemies")
onready var goal = get_parent().get_node("Homes")

var path = PoolVector2Array()
var enemy_count = []
var allow_spawn = true
var _timer = null

func _ready():
	path = get_parent().get_child(0).get_simple_path(global_position,goal.global_position+Vector2(32,16))
	add_child(creator)
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	randomize()
	_timer.set_wait_time(randi() % (SPAWNER_TIME*3) + SPAWNER_TIME)
	print(_timer.wait_time)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func _process(_delta):
	enforceEnemyCap(enemy_count)

func _on_Timer_timeout():
	if allow_spawn:
		enemy_count.append(spawnCreature(path))
		randomize()
		_timer.set_wait_time(randi() % (SPAWNER_TIME*3) + SPAWNER_TIME)
	print(_timer.wait_time)

func spawnCreature(new_path):
	if enemy_count.size() >= ENEMY_CAP:
		return
	var aggressivecreature = aggressiveCreature.instance()
	holder.add_child(aggressivecreature)
	aggressivecreature.global_position=global_position
	aggressivecreature.path = new_path
	aggressivecreature.createCharacter(creator.getTextureForCreature(ENEMY_NAMES[randi()%3],1,1))
	return aggressivecreature

func enforceEnemyCap(enemy_array):
	for enemy in enemy_array:
		if (!is_instance_valid(enemy)):
			enemy_array.erase(enemy)
	allow_spawn = (enemy_array.size() < ENEMY_CAP)

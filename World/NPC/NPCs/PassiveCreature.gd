extends KinematicBody2D

const CreatureCreator = preload("res://World/NPC/NPCs/SmallCreatureCreator.tscn")

func _ready():
	createCharacter()
	set_process(false)

func createCharacter():
	var creator = CreatureCreator.instance()
	$Texture.texture = creator.getTextureForCreature("worker")
	if $Texture.texture != null:
		creator.queue_free()

var speed : = 1.5
var path : = PoolVector2Array() setget set_path

func _process(delta):
	move_along_path()

func move_along_path():
	var start_point := position
	for _i in range(path.size()):
		var distance_to_next : = start_point.distance_to(path[0])
		if not distance_to_next < 1.0:
			var normal_dir = (path[0] - start_point)
			move_and_collide(normal_dir.normalized()*speed)
			break
		start_point = path[0]
		path.remove(0)

func set_path(value : PoolVector2Array):
	path = value
	if value.size() == 0:
		return
	set_process(true)

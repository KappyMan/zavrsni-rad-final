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

var speed : = 400
var path : = PoolVector2Array() setget set_path

func _process(delta):
	var move_distance = speed*delta
	move_along_path(move_distance)

func move_along_path(distance):
	var start_point := position
	for _i in range(path.size()):
		var distance_to_next : = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			move_and_collide(start_point.linear_interpolate(path[0], distance/distance_to_next))
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		distance-=distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value : PoolVector2Array):
	path = value
	if value.size() == 0:
		return
	set_process(true)

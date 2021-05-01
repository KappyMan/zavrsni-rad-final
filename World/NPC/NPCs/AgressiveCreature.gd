extends KinematicBody2D 

onready var texture = $Texture
onready var animation_player = $AnimationPlayer
onready var stats = $CreatureStats
onready var area = $Area2D

var collision_detect = null
var speed : = 1.5
var path : = PoolVector2Array() setget set_path
var walk_state = true
var attack_friendly = false
var attack_body = null

func _ready():
	area.monitoring = true
	$Area2D/CollisionShape2D2.disabled = false

func _process(_delta):
	if attack_friendly and attack_body != null:
		path = PoolVector2Array([global_position,attack_body.global_position])
		initCombat(attack_body)
	animation_control(walk_state)
	move_along_path()

func createCharacter(new_texture):
	texture.texture = new_texture

func move_along_path():
	var start_point := position
	for _i in range(path.size()):
		walk_state = false
		var distance_to_next : = start_point.distance_to(path[0])
		if not distance_to_next < 1.0:
			var normal_dir = (path[0] - start_point)
			collision_detect = move_and_collide(normal_dir.normalized()*speed)
			walk_state = true
			break
		start_point = path[0]
		path.remove(0)

func animation_control(state):
	if state:
		texture.scale = Vector2.ONE
		animation_player.play("zombie_walk")
		return
	texture.rotation_degrees = 0
	animation_player.play("zombie_idle")

func set_path(value : PoolVector2Array):
	path = value
	if value.size() == 0:
		return

func wonder():
	randomize()
	path = PoolVector2Array([Vector2(rand_range(-10,10),rand_range(-10,10)), global_position])

func _on_Timer_timeout():
	$Area2D/CollisionShape2D2.scale+=0.01*Vector2.ONE
	if !path.size():
		wonder()

func getTexture():
	return texture.texture

func initCombat(target_body):
	if collision_detect == null or target_body == null:
		return
	if target_body == collision_detect.collider:
		area.monitoring = false
		Global.initCombatScene(target_body.getTexture(), target_body.getHealth(),getTexture(),$CreatureStats._get_health(), target_body, self)
		target_body = null


func set_health(value):
	stats._set_health(value)

func get_health():
	return stats._get_health()

func get_max_health():
	return stats.max_health

func _on_Area2D_body_entered(body):
	path = PoolVector2Array([global_position, body.global_position])
	if attack_body == null:
		attack_body = body
		return
	attack_friendly = true


func _on_Area2D_body_exited(_body):
	attack_body = null

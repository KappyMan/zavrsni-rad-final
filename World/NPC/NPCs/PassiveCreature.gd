extends KinematicBody2D

const CreatureCreator = preload("res://World/NPC/NPCs/SmallCreatureCreator.tscn")

onready var texture = $Texture
onready var animation_player = $AnimationPlayer

var selected = false
var walk_state = false

func _ready():
	createCharacter()


func createCharacter():
	var creator = CreatureCreator.instance()
	texture.texture = creator.getTextureForCreature("boy")
	if texture.texture != null:
		creator.queue_free()

var speed : = 1.5
var path : = PoolVector2Array() setget set_path

func _process(_delta):
	animation_control(walk_state)
	move_along_path()

func move_along_path():
	var start_point := position
	for _i in range(path.size()):
		walk_state = false
		var distance_to_next : = start_point.distance_to(path[0])
		if not distance_to_next < 1.0:
			var normal_dir = (path[0] - start_point)
			move_and_collide(normal_dir.normalized()*speed)
			walk_state = true
			break
		start_point = path[0]
		path.remove(0)

func animation_control(state):
	if state:
		texture.scale = Vector2.ONE
		animation_player.play("walk")
		return
	texture.rotation_degrees = 0
	animation_player.play("idle")

func set_path(value : PoolVector2Array):
	path = value
	if value.size() == 0:
		return

func _on_Area2D_input_event(viewport, event, shape_idx):
	selected = ! selected
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		texture.get_material().set_shader_param("width",selected)

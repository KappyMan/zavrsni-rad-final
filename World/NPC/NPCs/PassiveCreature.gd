extends KinematicBody2D

const CreatureCreator = preload("res://World/NPC/NPCs/SmallCreatureCreator.tscn")

enum CurrentTask{
	wait,
	attack,
	walk,
	farm
}

signal selected_unit(emit_self)

export(String, "boy", "girl", "worker") var texture_type

onready var texture = $Texture
onready var animation_player = $AnimationPlayer

var speed : = 1.5
var path : = PoolVector2Array() setget set_path

var curr_task = CurrentTask.wait
var selected = false
var walk_state = false

func _ready():
	var mat = texture.get_material().duplicate(true)
	texture.set_material(mat)
	createCharacter()

func _process(_delta):
	taskMachine(curr_task)
	animation_control(walk_state)
	move_along_path()

func taskMachine(task):
	match task:
		CurrentTask.wait:
			#print("WAIT")
			pass
		CurrentTask.walk:
			#print("WALK")
			pass
		CurrentTask.attack:
			#print("ATTACK")
			pass
		CurrentTask.farm:
			#print("FARM")
			pass

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

func createCharacter():
	var creator = CreatureCreator.instance()
	texture.texture = creator.getTextureForCreature(texture_type)
	if texture.texture != null:
		creator.queue_free()

func onNewTask(value):
	curr_task = value

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	selected = ! selected
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		texture.get_material().set_shader_param("width",selected)
		emit_signal("selected_unit", self)

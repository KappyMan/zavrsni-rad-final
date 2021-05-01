extends KinematicBody2D

const Crop = preload("res://World/Crops/CropScenes/Crop.tscn")
const CreatureCreator = preload("res://World/NPC/NPCs/SmallCreatureCreator.tscn")

enum CurrentTask{
	wait,
	attack,
	walk,
	farm,
	click
}

signal selected_unit(emit_self)

export(String, "boy", "girl", "worker") var texture_type

onready var texture = $Texture
onready var animation_player = $AnimationPlayer
onready var creator = CreatureCreator.instance()
onready var stats = $CreatureStats

var speed : = 1.5
var path : = PoolVector2Array() setget set_path

var farming_parameters = [] setget set_farming_parameters
var curr_task = CurrentTask.wait

var selected = false
var walk_state = false

var can_plant = true
var last_location = []

var timer = null

func _ready():
	var mat = texture.get_material().duplicate(true)
	texture.set_material(mat)
	createCharacter()

func _process(_delta):
	taskMachine(curr_task)
	animation_control(walk_state)
	

func taskMachine(task):
	match task:
		CurrentTask.wait:
			move_along_path()
			_clear_farm_parameter()
			#print("WAIT")
			pass
		CurrentTask.walk:
			move_along_path()
			#print("WALK")
			pass
		CurrentTask.attack:
			#print("ATTACK")
			pass
		CurrentTask.farm:
			farm_land(farming_parameters[0],farming_parameters[1],farming_parameters[2])
			move_along_path()
			#print("FARM")
			pass
		CurrentTask.click:
			move_along_path()
			#print("CONTINUE")
			pass

func _clear_farm_parameter():
	if timer == null:
		timer = Timer.new()
		timer.connect("timeout",self,"_on_timer_timeout") 
		add_child(timer) 
		timer.wait_time = 60
		timer.start() 

func farm_land(tilemap,select_tile,tile_id):
	var location = tilemap.world_to_map(global_position)
	if select_tile.get_cellv(location) != TileMap.INVALID_CELL and tilemap.get_cellv(location) != tile_id:
		tilemap.set_cellv(location,tile_id)
		tilemap.update_bitmask_region(location-Vector2(1,1),location+Vector2(1,1))
	if tilemap.get_cellv(location) == tile_id and last_location.find(location) == -1:
		can_plant = true
		create_crop()
	last_location.append(location)


func create_crop():
	if can_plant:
		var crop = Crop.instance()
		crop._set_tile_coords(Global.floor_tile.world_to_map(global_position))
		Global.crops.add_child(crop)
		can_plant = false

func pool_has(pool, value):
	for v in pool:
		if v == value:
			return true
		return false

func move_along_path():
	var start_point := position
	for _i in range(path.size()):
		walk_state = false
		var distance_to_next : = start_point.distance_to(path[0])
		if not distance_to_next < 1.0:
			var normal_dir = (path[0] - start_point)
# warning-ignore:return_value_discarded
			move_and_collide(normal_dir.normalized()*speed)
			walk_state = true
			break
		start_point = path[0]
		path.remove(0)

func animation_control(state):
	if state:
		texture.scale = Vector2.ONE
		animation_player.play("human_walk")
		return
	texture.rotation_degrees = 0
	animation_player.play("human_idle")

func set_path(value : PoolVector2Array):
	path = value
	if value.size() == 0:
		return

func createCharacter():
	texture.texture = creator.getTextureForCreature(texture_type)
	if texture.texture != null:
		creator.queue_free()

func amISelected(selected_unit):
	if self != selected_unit:
		selected = false
		texture.get_material().set_shader_param("width",selected)

func onNewTask(value):
	curr_task = value

func getTexture():
	return texture.texture

func getHealth():
	return $CreatureStats._get_health()

func set_health(value):
	stats._set_health(value)

func get_health():
	return stats._get_health()

func get_max_health():
	return stats.max_health

func set_farming_parameters(parameters):
	farming_parameters += parameters

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	selected = ! selected
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		texture.get_material().set_shader_param("width",selected)
		emit_signal("selected_unit", self)

func _on_timer_timeout():
	last_location.clear()
	timer = null

extends Area2D

export(Vector2) var TILEMAP_TILE = Vector2(0,0) setget _set_tile_coords
export(int) var GROW_TIME_SPEED = 1

signal collected_resource(resource)

const GROW_RANGES = [60,20]

onready var particles = $Texture/Particles2D
onready var timer = $Timer
onready var texture_node = $Texture
onready var frames = texture_node.hframes 



func _ready():
	randomize()
	global_position = Global.floor_tile.map_to_world(TILEMAP_TILE) + Vector2(0,4)
	var new_texture = setCropTexture((randi() % 20))
	texture_node.texture = new_texture
	particles.texture = createIcon(new_texture)
	timer.set_wait_time(randomGrowTime())
	timer.start()
	growCrop()


func setCropTexture(id:int = 0):
	var current_id = str(id)
	if current_id.length() == 1:
		current_id = "0" + current_id
	return load("res://World/Crops/CropTextures/crop_" + str(current_id) + ".png")

func randomGrowTime():
	return (randi() % GROW_RANGES[0] + GROW_RANGES[1])/GROW_TIME_SPEED + 1

func growCrop():
	if frames:
		frames-=1
		texture_node.frame = frames
		return
	$AnimationPlayer.play("harvest")
	makeHarvestable()
	particles.emitting = true

func createIcon(frame_texture):
	var new_texture = ImageTexture.new()
	var img:Image = frame_texture.get_data()
	img.crop(16,16)
	new_texture.create_from_image(img)
	return new_texture

func makeHarvestable():
# warning-ignore:return_value_discarded
	connect("body_entered",self,"_on_Crop_pickup")
# warning-ignore:return_value_discarded
	connect("collected_resource",Global.game_ui,"addInventory")

func _set_tile_coords(value:Vector2):
	TILEMAP_TILE = value

func _on_Timer_timeout():
	if particles.emitting:
		return
	timer.set_wait_time(randomGrowTime())
	timer.start()
	growCrop()

func _on_Crop_pickup(_farmer):
	emit_signal("collected_resource",texture_node.texture.resource_path)
	queue_free()


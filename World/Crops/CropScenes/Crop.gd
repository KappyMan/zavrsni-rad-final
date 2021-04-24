extends Area2D

onready var timer = $Timer
onready var texture_node = $Texture
onready var frames = texture_node.hframes -1

func _ready():
	randomize()
	timer.set_wait_time((randi() % 61 + 20))
	timer.start()
	texture_node.texture = setCropTexture((randi() % 20))
	growCrop()

func setCropTexture(id:int = 0):
	var current_id = str(id)
	if current_id.length() == 1:
		current_id = "0" + current_id
		return
	print("res://World/Crops/CropTextures/crop_" + str(current_id) + ".png")
	return load("res://World/Crops/CropTextures/crop_" + str(current_id) + ".png")


func _on_Timer_timeout():
	timer.set_wait_time(rand_range(30,60))
	timer.start()
	growCrop()

func growCrop():
	if frames:
		frames-=1
		texture_node.frame = frames
		print(frames)
		return
	

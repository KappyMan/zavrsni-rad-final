extends Sprite
var new_texture = StreamTexture.new() setget setTexture
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setHealth(new_health):
	$CreatureStats._set_health(new_health)
	$AnimationPlayer.play("human_idle")

func setTexture(new_sprite):
	new_texture = new_sprite
	texture = new_texture

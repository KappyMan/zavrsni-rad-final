extends Sprite

onready var stats = $CreatureStats
onready var healthbar = $HealthBar
onready var shield = $HealthBar/TextureButton
var new_texture = StreamTexture.new() setget setTexture

func _ready():
	healthbar.max_value = stats.max_health
	healthbar.value = stats.max_health

func shieldUp():
	stats._set_shield(1)
	shield.pressed = stats.shield

func playAnimation(animation):
	$AnimationPlayer.play("human_"+animation)

func setHealth(new_health):
	healthbar.value = new_health
	stats._set_health(new_health)
	$AnimationPlayer.play("human_idle")

func setTexture(new_sprite):
	new_texture = new_sprite
	texture = new_texture

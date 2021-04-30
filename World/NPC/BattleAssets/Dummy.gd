extends Sprite

onready var stats = $CreatureStats
onready var healthbar = $HealthBar
onready var shield = $HealthBar/TextureButton
var new_texture = StreamTexture.new() setget setTexture

func _ready():
	healthbar.max_value = stats.max_health
	healthbar.value = stats.max_health/2

func shieldUp(state):
	stats._set_shield(state)
	shield.pressed = state

func healthManipulate(heal_or_hurt:int = 1):
	randomize()
	var heal_amount = heal_or_hurt*(randi()%3 + 1)
	stats.healthChange(heal_amount)

func healthbarUpdate(hp):
	print("HP")
	healthbar.value = hp

func shieldUpdate(shld):
	print("Shield")
	shieldUp(shld)

func playAnimation(animation):
	$AnimationPlayer.play("human_"+animation)

func setHealth(new_health):
	healthbar.value = new_health
	stats._set_health(new_health)
	$AnimationPlayer.play("human_idle")

func setTexture(new_sprite):
	new_texture = new_sprite
	texture = new_texture

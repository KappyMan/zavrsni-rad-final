extends Sprite

export(bool) var Enemy = false


onready var stats = $CreatureStats
onready var healthbar = $HealthBar
onready var shield = $HealthBar/TextureButton

var rival = null
var new_texture = StreamTexture.new() setget setTexture

func _ready():
	healthbar.max_value = stats.max_health
	healthbar.value = stats.max_health
	playAnimation("idle")

func shieldUp(state):
	$Audio/Shield.play()
	stats._set_shield(state)

func healthManipulate(heal_or_hurt:int = 1):
	randomize()
	if heal_or_hurt > 0:
		$Audio/Heal.play()
		$Particles2D.emitting = heal_or_hurt
	var heal_amount = heal_or_hurt*(randi()%5 + 1)
	stats.healthChange(heal_amount)

func healthbarUpdate(hp):
	healthbar.value = hp

func shieldUpdate(shld):
	shield.pressed = shld

func playAnimation(animation):
	$AnimationPlayer.play("human_"+animation)

func setMaxHealth(new_max_health):
	healthbar.max_value = new_max_health
	stats.max_health = new_max_health

func setHealth(new_health):
	healthbar.value = new_health
	stats._set_health(new_health)
	$AnimationPlayer.play("human_idle")

func getHealth():
	return stats._get_health()

func setTexture(new_sprite):
	new_texture = new_sprite
	texture = new_texture

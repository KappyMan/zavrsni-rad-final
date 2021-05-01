extends Node2D

const CAMERA_OFFSET = 10

onready var player_unit = $PlayerUnit
onready var enemy = $Enemy
onready var camera = $Camera2D
onready var tween = $Tween
onready var timer = $Timer

var multiplier = -1
var enemy_last_action = battleAction.Nothing

enum battleAction{
	Nothing,
	Attack,
	Shield,
	Heal
}

var action_selected = battleAction.Nothing setget _set_action_selected

func _ready():
	dummyPosition()
	multiplier=wobbleCamera(multiplier)

func _process(_delta):
	pass

func wobbleCamera(mul):
	tween.interpolate_property(
				camera,
				"position",
				Vector2(-CAMERA_OFFSET,randi() % CAMERA_OFFSET)*mul,
				Vector2(CAMERA_OFFSET,randi() % CAMERA_OFFSET)*mul,
				4,
				Tween.TRANS_SINE, 
				Tween.EASE_OUT
				)
	tween.start()
	return mul * (-1)

func dummyPosition():
	player_unit.global_position = -player_unit.global_position
	enemy.global_position = enemy.global_position
	enemy.flip_h = true

func setDummies(player_hp,player_tex,enemy_hp,enemy_tex, enmy, plyr):
	player_unit.rival = enmy
	player_unit.setTexture(player_tex)
	player_unit.setHealth(player_hp)
	player_unit.setMaxHealth(plyr.get_max_health())
	enemy.rival = plyr
	enemy.setTexture(enemy_tex)
	enemy.setHealth(enemy_hp)
	enemy.setMaxHealth(enmy.get_max_health())

func doAction(action):
	invertDisable()
	match action:
		battleAction.Attack:
			attack(player_unit,enemy)
		battleAction.Shield:
			shield(player_unit)
		battleAction.Heal:
			heal(player_unit)
		battleAction.Nothing:
			return
	yield(YieldProperly.yield_wait(3000, self), "completed")
	player_unit.playAnimation("idle")
	enemyTurn(enemy)
	yield(YieldProperly.yield_wait(3000, self), "completed")
	enemy.playAnimation("idle")
	invertDisable()
	action = battleAction.Nothing

func attack(unit, hurt_enemy):
	if !unit.Enemy:
		unit.playAnimation("attack")
		yield(YieldProperly.yield_wait(1000, self), "completed")
		hurt_enemy.healthManipulate(-1)
		return
	unit.playAnimation("attack_mirror")
	yield(YieldProperly.yield_wait(1000, self), "completed")
	hurt_enemy.healthManipulate(-1)

func shield(unit):
	unit.shieldUp(true)
	unit.playAnimation("shield")

func heal(unit):
	unit.healthManipulate()

func enemyTurn(enemy_unit):
	randomize()
	var rand_action = randi() % 4 
	if enemy_last_action == rand_action:
		enemyTurn(enemy_unit)
		return
	match rand_action:
		battleAction.Attack:
			attack(enemy_unit, player_unit)
		battleAction.Shield:
			shield(enemy_unit)
		battleAction.Heal:
			heal(enemy_unit)
		battleAction.Nothing:
			enemyTurn(enemy_unit)
	enemy_last_action = rand_action

func invertDisable():
	for action_icon in $CanvasLayer/UI/GridContainer.get_children():
		action_icon.disabled = !action_icon.disabled

func _on_Tween_tween_all_completed():
	multiplier=wobbleCamera(multiplier)

func _on_ActionButton_pressed():
	_set_action_selected(battleAction.Attack)

func _on_ActionButton2_pressed():
	_set_action_selected(battleAction.Shield)

func _on_ActionButton3_pressed():
	_set_action_selected(battleAction.Heal)

func _set_action_selected(value):
	action_selected = value
	doAction(action_selected)

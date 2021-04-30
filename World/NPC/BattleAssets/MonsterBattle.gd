extends Node2D

const CAMERA_OFFSET = 10

onready var timer = $Timer
onready var player_unit = $PlayerUnit
onready var enemy = $Enemy
onready var camera = $Camera2D
onready var tween = $Tween
var multiplier = -1

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

func setDummies(player_hp,player_tex,enemy_hp,enemy_tex):
	player_unit.setTexture(player_tex)
	player_unit.setHealth(player_hp)
	enemy.setTexture(enemy_tex)
	enemy.setHealth(enemy_hp)

func doAction(action):
	invertDisable()
	print("Player turn")
	match action:
		battleAction.Attack:
			attack(player_unit,enemy)
		battleAction.Shield:
			shield(player_unit)
		battleAction.Heal:
			heal(player_unit)
		battleAction.Nothing:
			return
	yield(get_tree().create_timer(4.0), "timeout")
	print("Enemy turn")
	enemyTurn(enemy)
	yield(get_tree().create_timer(4.0), "timeout")
	invertDisable()
	action = battleAction.Nothing


func attack(unit, hurt_enemy):
	if !unit.flip_h:
		unit.playAnimation("attack")
		yield(get_tree().create_timer(1.0), "timeout")
		hurt_enemy.healthManipulate(-1)
		return
	unit.playAnimation("attack_mirror")
	yield(get_tree().create_timer(1.0), "timeout")
	hurt_enemy.healthManipulate(-1)

func shield(unit):
	unit.shieldUp(true)
	unit.playAnimation("shield")

func heal(unit):
	unit.healthManipulate()

func enemyTurn(enemy_unit):
	randomize()
	var rand_action = randi() % 3 + 1
	match rand_action:
		battleAction.Attack:
			attack(enemy_unit, player_unit)
		battleAction.Shield:
			shield(enemy_unit)
		battleAction.Heal:
			heal(enemy_unit)

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

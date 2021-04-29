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
	var dummy_positions = Vector2(40,0)
	player_unit.global_position = -dummy_positions
	enemy.global_position = dummy_positions

func setDummies(player_hp,player_tex,enemy_hp,enemy_tex):
	player_unit.setTexture(player_tex)
	player_unit.setHealth(player_hp)
	enemy.setTexture(enemy_tex)
	enemy.setHealth(enemy_hp)

func doAction(action):
	invertDisable()
	match action:
		battleAction.Attack:
			attack(player_unit,-1)
		battleAction.Shield:
			shield(player_unit)
		battleAction.Heal:
			pass
		battleAction.Nothing:
			pass
	yield(get_tree().create_timer(5.0), "timeout")
	invertDisable()

func attack(unit,dir:int):
	unit.playAnimation("attack")
	tween.interpolate_property(player_unit,"position",position,dir*Vector2(40,0),2,Tween.TRANS_QUART, Tween.EASE_OUT,1)
	tween.start()

func shield(unit):
	unit.shieldUp()



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
	print(action_selected)

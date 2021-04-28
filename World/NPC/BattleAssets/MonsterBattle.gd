extends Node2D

onready var player_unit = $PlayerUnit
onready var enemy = $Enemy


# Called when the node enters the scene tree for the first time.
func _ready():
	dummyPosition()

func dummyPosition():
	var dummy_positions = Vector2(15,0)
	player_unit.global_position = -dummy_positions
	enemy.global_position = dummy_positions

func setDummies(player_hp,player_tex,enemy_hp,enemy_tex):
	player_unit.setTexture(player_tex)
	player_unit.setHealth(player_hp)
	enemy.setTexture(enemy_tex)
	enemy.setHealth(enemy_hp)

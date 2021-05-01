extends Control

const MonsterBattle = preload("res://World/NPC/BattleAssets/MonsterBattle.tscn")

onready var viewport = $ViewportContainer/Viewport
onready var container = $ViewportContainer
onready var monster_battle = $ViewportContainer/Viewport/MonsterBattle

var battle_start := false setget startBattle 

func _ready():
	container.rect_size = rect_size
	viewport.size = container.rect_size 
	set_process(false)

func _process(_delta):
	pass

func setFighterAssets(player_texture, player_health, enemy_texture, enemy_health, player, enemy):
	print("SetFight")
	monster_battle = MonsterBattle.instance()
	viewport.add_child(monster_battle)
	monster_battle.setDummies(player_health,player_texture,enemy_health,enemy_texture, player, enemy)
	rect_global_position = Vector2.ZERO

func finalizeFight():
	print("EndFight")
	monster_battle.queue_free()
	rect_global_position = Vector2(0,300)

func startBattle(value):
	set_process(value)

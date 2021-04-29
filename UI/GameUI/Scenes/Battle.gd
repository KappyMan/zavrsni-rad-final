extends Control

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

func setFighterAssets(player_texture, player_health, enemy_texture, enemy_health):
	monster_battle.setDummies(player_health,player_texture,enemy_health,enemy_texture)
	rect_global_position = Vector2.ZERO

func startBattle(_value):
	set_process(true)

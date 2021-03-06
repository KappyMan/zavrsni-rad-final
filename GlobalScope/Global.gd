extends Node

onready var root =  get_tree().get_current_scene() setget set_root
onready var floor_tile = root.get_child(0).get_child(0) setget set_floor_tile
onready var game_ui = root.get_node("UI/GameUI") setget set_game_ui
onready var crops = root.get_node("Crops") setget set_crops
onready var battle = root.get_node("UI/Battle") setget set_battle

var screen_metrics_dict = {}
var Global_game_state = GameState.PLAY
var combat_player = null
var combat_enemy = null

enum GameState{
	PLAY,
	STOP,
	LOADING
}

func _ready():
	
	if OS.is_debug_build():
		screen_metrics()

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files

func initCombatScene(player_unit_texture, player_unit_stats, enemy_unit_texture, enemy_unit_stats, player, enemy):
	combat_player = player
	combat_enemy = enemy
	if combat_enemy != null and combat_player != null:
		get_tree().paused = true
		battle.visible = true
		battle.battle_start = true
		battle.setFighterAssets(player_unit_texture, player_unit_stats, enemy_unit_texture, enemy_unit_stats, player, enemy)

func combat_finished(loser):
	if loser == combat_player:
		print("Winner: ENEMY")
		combat_enemy.area.monitoring = true
	else:
		print("Winner: PLAYER")
	combat_enemy = null
	combat_player = null
	battle.finalizeFight()
	battle.visible = true
	battle.battle_start = false
	get_tree().paused = false
	loser.queue_free()

func screen_metrics():
	screen_metrics_dict["Display"] = OS.get_screen_size()
	screen_metrics_dict["Decorated Window size"] = OS.get_real_window_size()
	screen_metrics_dict["Window_size"] = OS.get_window_size()
	print("                 Screen Metrics")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height"))

func reload_world_gloabally():
	print("here")
	set_root(get_tree().get_current_scene())
	set_floor_tile(root.get_child(0).get_child(0))
	set_game_ui(root.get_node("UI/GameUI"))
	set_crops(root.get_node("Crops"))
	set_battle(root.get_node("UI/Battle"))

func set_root(value):
	root = value
	print(value)

func set_floor_tile(value):
	floor_tile = value
	print(value)

func set_game_ui(value):
	game_ui = value
	print(value)

func set_crops(value):
	crops = value
	print(value)

func set_battle(value):
	battle = value
	print(value)

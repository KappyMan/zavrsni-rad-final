extends Node2D

const PassiveCreature = preload("res://World/NPC/NPCs/PassiveCreature.tscn")
const House = preload("res://World/Houses/House.tscn")

export var state = true

onready var pause_screen = $CanvasLayer/PauseScreen
onready var floor_tile = $Navigation/Floor
onready var select_tile = $SelectTile

onready var navigation = $Navigation
onready var line2d = $Line2D

var small_creature = null

func _ready():
	select_tile.visible = true

func _process(_delta):
	selectTileControl(select_tile, state)
	if Input.is_action_just_pressed("ui_down"):
		small_creature = PassiveCreature.instance()
		small_creature.global_position = getCellGlobalPosition(get_global_mouse_position(), floor_tile)
		add_child(small_creature)
	if Input.is_action_pressed("right_click"):
			var new_path = navigation.get_simple_path(small_creature.global_position,get_global_mouse_position())
			line2d.points = new_path
			small_creature.path = new_path

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			pause_screen.visible=!pause_screen.visible
			Global.Global_game_state = Global.GameState.STOP

func selectTileControl(tile_select, select_state:bool = false):
	if select_state:
		var pos = getCellGlobalPosition(get_global_mouse_position(), floor_tile)
		tile_select.global_position = pos
		if Input.is_action_just_pressed("ui_accept"):
			var house = House.instance()
			house.global_position = pos
			add_child(house)

func getCellGlobalPosition(globalPosition: Vector2, tilemap) -> Vector2:
	return to_global(tilemap.map_to_world(tilemap.world_to_map(to_local(globalPosition))))



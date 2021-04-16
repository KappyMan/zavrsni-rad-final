extends Node2D

const PassiveCreature = preload("res://World/NPC/NPCs/PassiveCreature.tscn")
const House = preload("res://World/Houses/House.tscn")

signal new_state(state)

enum ControlState {
	select,
	attack,
	walk,
	farm,
	click
}

onready var friendly = $Friendly
onready var camera = $Camera2D
onready var pause_screen = $CanvasLayer/PauseScreen

onready var floor_tile = $Navigation/Floor
onready var select_tile =$Navigation/SelectArea
onready var navigation = $Navigation
onready var line2d = $Line2D

var drag_points = []
var control_state = ControlState.click
var small_creature = null
var process_land = false

func _process(_delta):
	controlStateMachine(control_state)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			pause_screen.visible=!pause_screen.visible
			Global.Global_game_state = Global.GameState.STOP

func controlStateMachine(state):
	emit_signal("new_state",state)
	match(state):
		ControlState.select:
			setupForState(state)
			selectArea()
		ControlState.attack:
			setupForState(state)
		ControlState.walk:
			setupForState(state)
			walkController()
			plantWalk(process_land)
			spawnFriendly()
		ControlState.farm:
			setupForState(state)
			farmArea()
		ControlState.click:
			setupForState(state)

func getCellfromGlobalPosition(globalPosition: Vector2, tilemap) -> Vector2:
	return tilemap.world_to_map(to_local(globalPosition))

func spawnFriendly():
	if Input.is_action_just_pressed("ui_down"):
				small_creature = PassiveCreature.instance()
				small_creature.global_position = getCellfromGlobalPosition(get_global_mouse_position(), floor_tile)
				connect("new_state",small_creature,"onNewTask")
				add_child(small_creature)

func walkController():
	if Input.is_action_pressed("right_click") and small_creature != null:
		createPathPolygon(small_creature.global_position,get_global_mouse_position())

func selectArea():
	if Input.is_action_just_pressed("left_click"):
		select_tile.clear()
		drag_points.append(getCellfromGlobalPosition(get_global_mouse_position(),select_tile))
		return
	if Input.is_action_just_released("left_click"):
		drag_points.append(getCellfromGlobalPosition(get_global_mouse_position(),select_tile))
		return
	if drag_points.size() == 2:
		var rect = Rect2()
		rect.position = drag_points[0]
		rect.end = drag_points[1]
		rect = rect.abs()
		createRectangle(rect)
		select_tile.update_bitmask_region()
		drag_points.clear()

func farmArea():
	var world_coords = []
	var coordinates = select_tile.get_used_cells()
	coordinates.sort()
	for coord in coordinates.size():
		world_coords.append(select_tile.map_to_world(coordinates[coord]))
	small_creature.path = PoolVector2Array(world_coords)
	control_state = ControlState.walk
	process_land = !process_land

func plantWalk(work:bool):
	if small_creature != null:
		var location = floor_tile.world_to_map(small_creature.global_position)
		if !work:
			return
		if select_tile.get_cellv(location) != TileMap.INVALID_CELL and floor_tile.get_cellv(location) != 2:
			print("Here" + str(location))
			floor_tile.set_cellv(location,2)
			floor_tile.update_bitmask_region(location-Vector2(1,1),location+Vector2(1,1))

func createRectangle(rect:Rect2):
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			select_tile.set_cell(x, y, 0)

func setupForState(current_state):
	camera.set_drag_mode(!(current_state/ControlState.click-1))

func createPathPolygon(path_origin, path_end):
	var new_path = navigation.get_simple_path(path_origin, path_end, false)
	line2d.points = new_path
	small_creature.path = new_path

func _on_GameUI_update_control_state(new_state):
	control_state = ControlState.get(new_state)

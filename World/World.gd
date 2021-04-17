extends Node2D

const PassiveCreature = preload("res://World/NPC/NPCs/PassiveCreature.tscn")
const House = preload("res://World/Houses/House.tscn")

signal register_select(selected_child)
signal new_task(new_task)

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

var all_friendlies = []
var drag_points = []
var control_state = ControlState.click
var small_creature = null
var path_given = false

func _ready():
	all_friendlies += getAllFriendlies(friendly)

func _process(_delta):
	print()
	controlStateMachine(control_state)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			pause_screen.visible=!pause_screen.visible
			Global.Global_game_state = Global.GameState.STOP

func controlStateMachine(state):
	#print(ControlState.keys()[state])
	match(state):
		ControlState.select:
			setupForState(state)
			selectArea()
		ControlState.attack:
			setupForState(state)
		ControlState.walk:
			setupForState(state)
			walkController()
			spawnFriendly()
		ControlState.farm:
			setupForState(state)
			farmArea()
		ControlState.click:
			setupForState(state)

func getAllFriendlies(parent):
	var connect_children = parent.get_children()
	for i in connect_children.size():
		connect_children[i].connect("selected_unit",Global.root,"selectedUnit")
# warning-ignore:return_value_discarded
		connect("register_select", connect_children[i], "amISelected")
	return connect_children

func selectedUnit(new_unit):
	if small_creature == null:
		small_creature = new_unit
# warning-ignore:return_value_discarded
		connect("new_task",small_creature,"onNewTask")
		return
	if !is_connected("new_task",small_creature,"onNewTask"):
		disconnect("new_task",small_creature,"onNewTask")
		small_creature = new_unit
# warning-ignore:return_value_discarded
		connect("new_task",small_creature,"onNewTask")
	emit_signal("register_select",new_unit)

func getCellfromGlobalPosition(globalPosition: Vector2, tilemap) -> Vector2:
	return tilemap.world_to_map(to_local(globalPosition))

func spawnFriendly():
	if Input.is_action_just_pressed("ui_down"):
				small_creature = PassiveCreature.instance()
				small_creature.global_position = getCellfromGlobalPosition(get_global_mouse_position(), floor_tile)
# warning-ignore:return_value_discarded
				connect("new_task",small_creature,"onNewTask")
				add_child(small_creature)

func walkController():
	if Input.is_action_pressed("right_click") and small_creature != null:
		createPathPolygon(small_creature.global_position,get_global_mouse_position())

func selectArea():
	if Input.is_action_just_pressed("left_click"):
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
		if drag_points[0] == drag_points[1]:
			select_tile.clear()
		drag_points.clear()

func farmArea():
	var world_coords = []
	var coordinates = select_tile.get_used_cells()
	coordinates.sort()
	for coord in coordinates.size():
		world_coords.append(select_tile.map_to_world(coordinates[coord]))
	if small_creature == null:
		return
	if !small_creature.path.size() and !path_given:
		small_creature.path = PoolVector2Array(world_coords)
		path_given = !path_given
	if !small_creature.path.size():
		path_given = !path_given
		control_state = ControlState.select
	small_creature.set_farming_parameters([floor_tile,select_tile,2])

func createRectangle(rect:Rect2):
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			select_tile.set_cell(x, y, 0)

func setupForState(current_state):
	emit_signal("new_task",current_state)
	camera.set_drag_mode(!(current_state/ControlState.click-1))

func createPathPolygon(path_origin, path_end):
	var new_path = navigation.get_simple_path(path_origin, path_end, false)
	line2d.points = new_path
	small_creature.path = new_path

func _on_GameUI_update_control_state(new_state):
	control_state = ControlState.get(new_state)

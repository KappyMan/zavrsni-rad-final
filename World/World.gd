extends Node2D

const PassiveCreature = preload("res://World/NPC/NPCs/PassiveCreature.tscn")
const House = preload("res://World/Houses/House.tscn")

enum ControlState {
	select,
	attack,
	walk,
	farm,
	click
}

onready var camera = $Camera2D
onready var pause_screen = $CanvasLayer/PauseScreen
onready var floor_tile = $Navigation/Floor
onready var select_tile =$SelectArea

onready var navigation = $Navigation
onready var line2d = $Line2D

var drag_points = []

var control_state = ControlState.click

var small_creature = null

func _process(_delta):
	controlStateMachine(control_state)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			pause_screen.visible=!pause_screen.visible
			Global.Global_game_state = Global.GameState.STOP

func controlStateMachine(state):
	match(state):
		ControlState.select:
			setupForState(state)
			selectArea()
		ControlState.attack:
			setupForState(state)
		ControlState.walk:
			setupForState(state)
			if Input.is_action_just_pressed("ui_down"):
				small_creature = PassiveCreature.instance()
				small_creature.global_position = getCellfromGlobalPosition(get_global_mouse_position(), floor_tile)
				add_child(small_creature)
			if Input.is_action_pressed("right_click") and small_creature != null:
				createPathPolygon(small_creature.global_position,get_global_mouse_position())
		ControlState.farm:
			setupForState(state)
		ControlState.click:
			setupForState(state)

func getCellfromGlobalPosition(globalPosition: Vector2, tilemap) -> Vector2:
	return tilemap.world_to_map(to_local(globalPosition))

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
		print(rect)
		createRectangle(rect)
		rect = null
		select_tile.update_bitmask_region()
		drag_points.clear()

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

extends Control

onready var cell_grid = $CellGrid
onready var action_grid = $ActionGrid

signal update_control_state(new_state)

var action_array = []
var cell_array = []

var current_button = null setget set_current_button

func _ready():
	getAllCells(cell_grid,cell_array)
	getAllCells(action_grid,action_array)
	setupCells(cell_array)
	setupCells(action_array)

func getAllCells(grid:GridContainer, array:Array):
	for cell in grid.get_children():
		array.append(cell)
	grid.columns = array.size()

func setupCells(array):
	for cell in len(array):
		if array[cell].connect("button_down",self,"toggleOneCell",[array[cell],array]) == OK:
			if array == cell_array:
				array[cell].shortcut = addShortcutToCell(cell)

func addShortcutToCell(index:int = 0):
	var shortcut=ShortCut.new()
	var action_name = "slot_"+str(index)
	var action = InputMap.get_action_list(action_name).pop_front()
	shortcut.set_shortcut(action)
	return shortcut

func toggleOneCell(returner, desired_array):
	for cell in desired_array:
		if cell == returner:
			set_current_button(returner.texture_normal.get_path())
		cell.pressed = false

func set_current_button(value):
	determineMode(value)
	current_button = value

func determineMode(texture:String):
	texture = texture.trim_prefix("res://UI/GameUI/Graphics/CellIcons/tile_")
	texture =texture.trim_suffix(".png")
	emit_signal("update_control_state", texture)

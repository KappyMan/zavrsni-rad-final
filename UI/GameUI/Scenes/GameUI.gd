extends Control

onready var cell_grid = $CellGrid
onready var action_grid = $ActionGrid

signal update_control_state(new_state)

var action_array = []
var cell_array = []
var item_count = []
var item_reference = []
var current_inventory = []

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
				array[cell].shortcut = addShortcutToCell("slot_",cell)
			if array == action_array:
				array[cell].shortcut = addShortcutToCell("action_",cell)

func addShortcutToCell(sufix, index:int = 0):
	var shortcut=ShortCut.new()
	var action_name = sufix+str(index)
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

func displayInventory(cell_slots, count_array, items):
	for cell in len(cell_slots):
		if cell >= items.size():
			break
		var cell_texture = cell_slots[cell].get_child(0)
		if cell_texture.texture == null:
			cell_texture.texture = createIcon(items[cell])
			#current_inventory.append(items[cell])
		cell_slots[cell].get_child(1).text = str(count_array[cell])

func createIcon(path):
	var texture = load(path)
	var img = Image.new()
	img = texture.get_data()
	img.crop(16,16)
	var new_texture = ImageTexture.new()
	new_texture.create_from_image(img,0)
	return new_texture

func addInventory(resource):
	var seach_index = item_reference.find(resource)
	if seach_index != -1:
		item_count[seach_index]+=1
		displayInventory(cell_array, item_count, item_reference)
		return
	if item_reference.size() < 9:
		item_reference.append(resource)
		item_count.append(1)
		displayInventory(cell_array, item_count, item_reference)
		return




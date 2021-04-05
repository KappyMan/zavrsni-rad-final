extends Node2D

const House = preload("res://World/Houses/House.tscn")

export var state = true

onready var floor_tile = $Enviorment/Floor
onready var select_tile = $SelectTile

func _ready():
	select_tile.visible = true

func _process(delta):
	selectTileControl(select_tile, state)

func selectTileControl(tile_select, state:bool = false):
	if state:
		var pos = getCellGlobalPosition(get_global_mouse_position(), floor_tile)
		tile_select.global_position = pos
		if Input.is_action_just_pressed("ui_accept"):
			var house = House.instance()
			house.global_position = pos
			add_child(house)

func getCellGlobalPosition(globalPosition: Vector2, tilemap) -> Vector2:
	return to_global(tilemap.map_to_world(tilemap.world_to_map(to_local(globalPosition))))

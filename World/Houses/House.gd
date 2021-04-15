extends StaticBody2D

export(bool) var flip_texture = false 
export(int) var upgrade_stage = 0 

var home_locations =   ["res://World/WorldTextures/HousesTexture/pixel_village_africans.png",
						"res://World/WorldTextures/HousesTexture/pixel_village_anatolians.png",
						"res://World/WorldTextures/HousesTexture/pixel_village_arabians.png",
						"res://World/WorldTextures/HousesTexture/pixel_village_asians.png",
						"res://World/WorldTextures/HousesTexture/pixel_village_europeans.png",
						"res://World/WorldTextures/HousesTexture/pixel_village_iroquois.png",
						"res://World/WorldTextures/HousesTexture/pixel_village_islanders.png",
						"res://World/WorldTextures/HousesTexture/pixel_village_norskers.png"]

onready var style = $Style

func _ready():
	apply_parameters(flip_texture, upgrade_stage)
	select_style_random()

func select_style_random():
	style.texture = load(home_locations[0])

func upgrade(tier):
	if tier < 3 and tier >= 0:
		style.frame = tier

func apply_parameters(flip, upgrade):
	style.flip_h = flip
	upgrade(upgrade)



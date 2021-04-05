extends StaticBody2D

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
	select_style_random()

func select_style_random():
	randomize()
	style.texture = load(home_locations[rand_range(0,8)])

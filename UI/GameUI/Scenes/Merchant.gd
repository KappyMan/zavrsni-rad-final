extends Control

signal update_net_worth(new_net_worth)

onready var animationplayer = $AnimationPlayer
onready var orbit = $Cart/Orbit
onready var purple = $Cart/Purple
onready var tween = $Tween
onready var timer = $Timer
onready var item_grid = $TradeOffer/Items
onready var price_tag = $TradeOffer/TextureRect/Deal/CenterContainer/GridContainer/Label

var net_worth = 0 setget set_net_worth

var item_cells = []

func _ready():
# warning-ignore:return_value_discarded
	connect("update_net_worth",get_parent(), "newNetWorth")
	getAllCells(item_grid, item_cells)

func merchantAppear():
	animationplayer.play("chill")
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func merchantDisappear():
	animationplayer.play("talk")
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func merchantOfferCreation(players_inventory, quantity):
	var item = -1
	var itemsToBuy = choosePlayerWare(players_inventory)
	giveOfferPrice(itemsToBuy,players_inventory,quantity)
	for item_slot in item_cells:
		item+=1
		if item >= itemsToBuy.size():
			return
		item_slot.get_child(0).texture = createIcon(itemsToBuy[item])
		item_slot.get_child(1).text = str(quantity[players_inventory.find(itemsToBuy[item])])

func giveOfferPrice(buying, inventory, amount):
	var item_value = ""
	var total_price = 0
	for item in len(buying):
		item_value = buying[item].trim_prefix("res://World/Crops/CropTextures/crop_")
		item_value = item_value.trim_suffix(".png")
		total_price += (int(item_value)+1) * stepify(amount[inventory.find(buying[item])] * 10 * randf(),1)
	set_net_worth(net_worth + total_price)
	price_tag.text = str(total_price)


func getAllCells(grid:GridContainer, array:Array):
	for cell in grid.get_children():
		array.append(cell)

func createIcon(path):
	var texture = load(path)
	var img = Image.new()
	img = texture.get_data()
	img.crop(16,16)
	var new_texture = ImageTexture.new()
	new_texture.create_from_image(img,0)
	return new_texture

func choosePlayerWare(player_ware):
	var choosenWares = []
	for _i in range(0,3):
		var choosenCrop = player_ware[randi() % player_ware.size()]
		if choosenWares.find(choosenCrop) > -1:
			break
		choosenWares.append(choosenCrop)
	return choosenWares

func set_net_worth(value):
	net_worth = value

func _on_Tween_tween_all_completed():
	purple.emitting = !purple.emitting
	orbit.emitting = !orbit.emitting
	animationplayer.play("levitate")

func _on_Timer_timeout():
	visible = true
	merchantAppear()

func _on_Confirm_pressed():
	$AudioStreamPlayer.play()
	merchantDisappear()
	emit_signal("update_net_worth",net_worth)

func _on_Decline_pressed():
	merchantDisappear()

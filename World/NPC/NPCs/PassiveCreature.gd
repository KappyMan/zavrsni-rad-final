extends KinematicBody2D

const CreatureCreator = preload("res://World/NPC/NPCs/SmallCreatureCreator.tscn")

func _ready():
	createCharacter()

func createCharacter():
	var creator = CreatureCreator.instance()
	$Texture.texture = creator.getTextureForCreature("worker")
	if $Texture.texture != null:
		creator.queue_free()

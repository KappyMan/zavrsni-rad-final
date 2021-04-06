extends Node

const folder_location = "res://World/NPC/NPCTextures/SmallCreatures/"

enum CreatureCategory{
	Passive,
	Agressive
}
enum CreatureState{Dead, Alive}

func getTextureForCreature(creature_name:String = "",category_creature:int = 0, state_creature:int = 1):
	var type_path = texturesByCreatureParameters(category_creature,state_creature)
	if !creature_name.empty():
		if state_creature:
			return load(type_path+creature_name+".png")
		elif !state_creature:
			return load(type_path+"dead_"+creature_name+".png")
	else:
		print_debug("Error loading Texture")


func texturesByCreatureParameters(category:int = 0, state:int = 1):
	var creature_state = CreatureState.keys()[state]
	var creature_category = CreatureCategory.keys()[category]
	return (folder_location+creature_category+"/"+creature_state+"/")




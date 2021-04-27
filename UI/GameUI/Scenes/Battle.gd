extends Control

onready var viewport = $ViewportContainer/Viewport
onready var container = $ViewportContainer

var battle_start := false setget startBattle 

func _ready():
	container.rect_size = rect_size
	viewport.size = container.rect_size 
	set_process(false)

func _process(_delta):
	print("Helloworld")

func startBattle(_value):
	set_process(true)

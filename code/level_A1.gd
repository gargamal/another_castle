extends "res://code/level.gd"

onready var lamp_light_scene = preload("res://scene/item/lamp_light.tscn")
onready var square_light_scene = preload("res://scene/item/square_light.tscn")
onready var torch_light_scene = preload("res://scene/item/torch_light.tscn")

func _ready():
	dict_scene["lamp"] = lamp_light_scene
	dict_scene["square"] = square_light_scene
	dict_scene["torch"] = torch_light_scene
	
	if not GLOBAL.is_restart:
		var menu = preload("res://scene/menu/menu_general.tscn").instance()
		add_child(menu)
	GLOBAL.is_restart = false
	
	add_cave_background()
	
	$dark_light.color = Color("#323232")
	
	spawn_object($lights, ["lamp", "square", "torch"])


func add_cave_background():
	for i in range(0, 16):
		for j in range(0, 16):
			var new_node = get_node("cave").duplicate()
			add_child(new_node)
			move_child(new_node, 1)
			new_node.offset = Vector2(1920 * i, 1280 * j)

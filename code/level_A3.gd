extends "res://code/level.gd"


onready var torch_light_scene = preload("res://scene/item/torch_light.tscn")


func _ready():
	dict_scene["torch"] = torch_light_scene
	$dark_light.color = Color("#222222")
	add_cave_background()
	spawn_object($lights, ["torch"])
	$weather.set_weather(50, $weather.CAVERN)


func add_cave_background():
	for i in range(0, 16):
		for j in range(0, 16):
			var new_node = get_node("cave").duplicate()
			add_child(new_node)
			move_child(new_node, 1)
			new_node.offset = Vector2(1920 * i, 1280 * j)

extends "res://code/level.gd"


onready var torch_light_scene = preload("res://scene/item/torch_light.tscn")


func _ready():
	dict_scene["torch"] = torch_light_scene
	$dark_light.color = Color("#222222")
	add_cave_background()
	spawn_object($lights, ["torch"])
	$weather.active($weather.CAVERN)
	$weather.amount(50, $weather.CAVERN)
	
	$weather.active($weather.FOG)
	$weather.amount(1000, $weather.FOG)
	$weather.modulate(Color(1, 1, 1, 0.02), $weather.FOG)
	$weather.speed(10.0, 0.0, 0.0, 110, $weather.FOG)


func add_cave_background():
	for i in range(0, 16):
		for j in range(0, 16):
			var new_node = get_node("cave").duplicate()
			add_child(new_node)
			move_child(new_node, 1)
			new_node.offset = Vector2(1920 * i, 1280 * j)

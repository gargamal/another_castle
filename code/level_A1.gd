extends "res://code/level.gd"

func _ready():
	if not GLOBAL.is_restart:
		var menu = preload("res://scene/menu/menu_general.tscn").instance()
		add_child(menu)
	GLOBAL.is_restart = false
	
	add_cave_background()


func add_cave_background():
	for i in range(0, 16):
		for j in range(0, 16):
			var new_node = get_node("cave").duplicate()
			add_child(new_node)
			move_child(new_node, 1)
			new_node.offset = Vector2(1920 * i, 1280 * j)

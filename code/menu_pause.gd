extends CanvasLayer

enum {CONTINUE, RESTART, OPTION, QUIT}

func _ready():
	get_tree().paused = true


func _on_menu_selected_item(value):
	match value:
		CONTINUE:
			get_tree().paused = false
			queue_free()
		RESTART:
			get_tree().paused = false
			GLOBAL.restart()
			get_tree().change_scene("res://scene/level/level_A1.tscn")
			queue_free()
		OPTION:
			var menu = preload("res://scene/menu/menu_action_remap.tscn").instance()
			get_tree().current_scene.add_child(menu)
		QUIT:
			get_tree().quit()


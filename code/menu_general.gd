extends CanvasLayer

enum {START, SCORE, OPTION, QUIT}

func _ready():
	get_tree().paused = true


func _on_menu_selected_item(value):
	var menu
	match value:
		START:
			get_tree().paused = false
			queue_free()
		SCORE:
			menu = preload("res://scene/menu/menu_score.tscn").instance()
			get_tree().current_scene.add_child(menu)
		OPTION:
			menu = preload("res://scene/menu/menu_action_remap.tscn").instance()
			get_tree().current_scene.add_child(menu)
		QUIT:
			get_tree().quit()


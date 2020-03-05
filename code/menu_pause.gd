extends CanvasLayer


func _ready():
	get_tree().paused = true


func _on_menu_selected_item(value):
	match value:
		0:
			get_tree().paused = false
			queue_free()
		1:
			get_tree().paused = false
			GLOBAL.is_restart = true
			get_tree().reload_current_scene()
			queue_free()
		2:
			var menu = preload("res://scene/menu_action_remap.tscn").instance()
			get_tree().current_scene.add_child(menu)
		3:
			get_tree().quit()


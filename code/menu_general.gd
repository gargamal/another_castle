extends CanvasLayer


func _ready():
	get_tree().paused = true


func _on_menu_selected_item(value):
	match value:
		0:
			get_tree().paused = false
			queue_free()
		1:
			var menu = preload("res://scene/menu_action_remap.tscn").instance()
			get_tree().current_scene.add_child(menu)
		2:
			get_tree().quit()


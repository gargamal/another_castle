extends CanvasLayer


func _ready():
	get_tree().paused = true



func _on_menu_selected_item(value):
	match value:
		0:
			get_tree().paused = false
		1:
			get_tree().paused = false
			get_tree().reload_current_scene()
		2:
			print("implement pause")
			get_tree().paused = false
		3:
			get_tree().quit()
	
	queue_free()


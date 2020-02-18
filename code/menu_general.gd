extends CanvasLayer


func _ready():
	get_tree().paused = true


func _on_menu_selected_item(value):
	match value:
		0:
			get_tree().paused = false
		1:
			print("implement pause")
			get_tree().paused = false
		2:
			get_tree().quit()
	
	queue_free()


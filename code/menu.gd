extends VBoxContainer


signal selected_item(value)


var cur_position = 0
var next_position = 0
var max_position = 0
var lst = []

func _ready():
	var screen_size = get_viewport_rect().size
	print(get_viewport_rect().size)
	
	lst = get_children()
	for i in range(1, lst.size()):
		lst[i].modulate.a = 0.3
		
	max_position = lst.size() - 1


func _process(delta):
	if Input.is_action_just_pressed("ui_down"): next_position += 1
	elif Input.is_action_just_pressed("ui_up"): next_position -= 1
	elif Input.is_action_just_pressed("ui_accept"):
		emit_signal("selected_item", cur_position)
		set_process(false)
		return
		
	if cur_position != next_position:
		next_position = clamp(next_position, 0, max_position)
		change_position(next_position)
		cur_position = next_position


func change_position(position):
	for i in range(lst.size()):
		lst[i].modulate.a = 1.0 if i == position else 0.3
		


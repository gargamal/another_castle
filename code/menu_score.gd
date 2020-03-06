extends CanvasLayer

func _ready():
	var elt_list = $background/container/list/winner
	var list = $background/container/list
	
	for line in GLOBAL.lst_score:
		var new_node = elt_list.duplicate()
		new_node.visible = true
		new_node.get_node("name").text = line[GLOBAL.NAME]
		new_node.get_node("score").text = str(line[GLOBAL.SCORE])
		list.add_child(new_node)


func _process(delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		var inst = null
		if get_parent().has_node("menu_general/background/menu"):
			inst = get_parent().get_node("menu_general/background/menu")
		if inst:
			inst.set_process(true)
			
		queue_free()
		return 

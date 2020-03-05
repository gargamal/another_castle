extends CanvasLayer

enum { UI_CASSOULET, UI_DASH, UI_DOWN, UI_LEFT, UI_RIGHT, UI_UP, UI_JUMP, UI_THROW, QUIT }

var is_waiting_action = false
var menu_action = QUIT

func _ready():
	$background/menu/ui_cassoulet.set_title("Use Cassoulet")
	$background/menu/ui_cassoulet.set_input_key(GLOBAL.dict_param["ui_cassoulet"])
	$background/menu/ui_dash.set_title("Use Dash")
	$background/menu/ui_dash.set_input_key(GLOBAL.dict_param["ui_dash"])
	$background/menu/ui_down.set_title("Down")
	$background/menu/ui_down.set_input_key(GLOBAL.dict_param["ui_down"])
	$background/menu/ui_left.set_title("Left")
	$background/menu/ui_left.set_input_key(GLOBAL.dict_param["ui_left"])
	$background/menu/ui_right.set_title("Right")
	$background/menu/ui_right.set_input_key(GLOBAL.dict_param["ui_right"])
	$background/menu/ui_up.set_title("Up")
	$background/menu/ui_up.set_input_key(GLOBAL.dict_param["ui_up"])
	$background/menu/ui_jump.set_title("Jump")
	$background/menu/ui_jump.set_input_key(GLOBAL.dict_param["ui_jump"])
	$background/menu/ui_throw_hammer.set_title("Throw Weapon")
	$background/menu/ui_throw_hammer.set_input_key(GLOBAL.dict_param["ui_throw_hammer"])


func _input(event):
	if is_waiting_action:
		match menu_action:
			UI_CASSOULET:
				$background/menu/ui_cassoulet.new_input_key(event.scancode, "ui_cassoulet")
			UI_DASH:
				$background/menu/ui_dash.new_input_key(event.scancode, "ui_dash")
			UI_DOWN:
				$background/menu/ui_down.new_input_key(event.scancode, "ui_down")
			UI_LEFT:
				$background/menu/ui_left.new_input_key(event.scancode, "ui_left")
			UI_RIGHT:
				$background/menu/ui_right.new_input_key(event.scancode, "ui_right")
			UI_UP:
				$background/menu/ui_up.new_input_key(event.scancode, "ui_up")
			UI_JUMP:
				$background/menu/ui_jump.new_input_key(event.scancode, "ui_jump")
			UI_THROW: 
				$background/menu/ui_throw_hammer.new_input_key(event.scancode, "ui_throw_hammer")
				
		is_waiting_action = false
		$background/menu.set_process(true)


func _on_menu_selected_item(value):
	menu_action = value
	match value:
		UI_CASSOULET:
			$background/menu/ui_cassoulet.waiting()
			$delay.start()
		UI_DASH:
			$background/menu/ui_dash.waiting()
			$delay.start()
		UI_DOWN:
			$background/menu/ui_down.waiting()
			$delay.start()
		UI_LEFT:
			$background/menu/ui_left.waiting()
			$delay.start()
		UI_RIGHT:
			$background/menu/ui_right.waiting()
			$delay.start()
		UI_UP:
			$background/menu/ui_up.waiting()
			$delay.start()
		UI_JUMP:
			$background/menu/ui_jump.waiting()
			$delay.start()
		UI_THROW: 
			$background/menu/ui_throw_hammer.waiting()
			$delay.start()
		QUIT:
			var inst = get_parent().get_node("menu_general/background/menu")
			if inst == null:
				inst = get_parent().get_node("menu_pause/background/menu")
				
			if inst:
				inst.set_process(true)
			
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			queue_free()


func _on_delay_timeout():
	is_waiting_action = true

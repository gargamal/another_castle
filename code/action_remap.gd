extends HBoxContainer

func set_title(title):
	$title.text = title

func set_input_key(value):
	$input_key.text = OS.get_scancode_string(value)
#	GLOBAL.save_data()


func waiting():
	$input_key.text = "pressed key..."


func new_input_key(value, key_name):
	set_input_key(value)
	GLOBAL.dict_param[key_name] = value
	GLOBAL.save_data()
	GLOBAL.add_input_event(key_name)

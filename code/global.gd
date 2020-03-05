extends Node


enum {LEFT, RIGHT, UP, DOWN}


var direction = RIGHT setget set_direction
var is_restart = false


const LIFE_MAX = 10
var life = 3
const CASSOULET_MAX = 100
var cassoulet = 0
var score = 0

var dict_param = []

enum {HAS_HAMMER, NO_HAMMER}
var weapon = HAS_HAMMER
enum {JEAN_BALAIS, SUPER_MARIOLLE}
var transformation = JEAN_BALAIS


const FILE_CONFIGURATION = "user://configuration.save"


func _ready():
	var file_save = File.new()
	
	if not file_save.file_exists(FILE_CONFIGURATION):
		save_data(file_save, true)
	else:
		load_data(file_save)


func add_input_event(action):	
	var event = InputEventKey.new()
	InputMap.action_erase_events(action)
	event.scancode = int(dict_param[action])
	InputMap.action_add_event(action, event)


func load_data(file_save):
	file_save.open(FILE_CONFIGURATION, File.READ)
	dict_param = parse_json(file_save.get_line())
	life = int(dict_param["life"])
	cassoulet = int(dict_param["cassoulet"])
	score = int(dict_param["score"])
	add_input_event("ui_right")
	add_input_event("ui_left")
	add_input_event("ui_up")
	add_input_event("ui_down")
	add_input_event("ui_jump")
	add_input_event("ui_dash")
	add_input_event("ui_throw_hammer")
	add_input_event("ui_cassoulet")
	file_save.close()


func save_data(file_save = File.new(), default = false):
	var dict_save = {
			"life": life,
			"cassoulet": cassoulet,
			"score": score,
			"ui_right": InputMap.get_action_list("ui_right")[0].scancode,
			"ui_left": InputMap.get_action_list("ui_left")[0].scancode,
			"ui_up": InputMap.get_action_list("ui_up")[0].scancode,
			"ui_down": InputMap.get_action_list("ui_down")[0].scancode,
			"ui_jump": InputMap.get_action_list("ui_jump")[0].scancode,
			"ui_dash": InputMap.get_action_list("ui_dash")[0].scancode,
			"ui_throw_hammer": InputMap.get_action_list("ui_throw_hammer")[0].scancode,
			"ui_cassoulet": InputMap.get_action_list("ui_cassoulet")[0].scancode,
		}
	file_save.open(FILE_CONFIGURATION, File.WRITE)
	file_save.store_line(to_json(dict_save if default else dict_param))
	file_save.close()


func set_direction(dir):
	direction = dir


func is_super_mariolle():
	return transformation == SUPER_MARIOLLE


func is_jean_du_balais():
	return transformation == JEAN_BALAIS


func has_hammer():
	return weapon == HAS_HAMMER


func has_cassoulet():
	return cassoulet > 0

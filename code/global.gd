extends Node

enum {LEFT, RIGHT, UP, DOWN}
enum {NAME, SCORE}

var direction = RIGHT setget set_direction
var is_restart = false

const LIFE_MAX = 10
var life = 3
const CASSOULET_MAX = 100
var cassoulet = 0
var score = 0
const MAX_TIME_LEFT = 1000
var time_left = MAX_TIME_LEFT
var nb_tick_cassoulet = 0
var MAX_TICK_CASSOULET = 100

var dict_param = []
var lst_score = []

enum {HAS_HAMMER, NO_HAMMER}
var weapon = HAS_HAMMER
enum {JEAN_BALAIS, SUPER_MARIOLLE}
var transformation = JEAN_BALAIS


const FILE_CONFIGURATION = "user://configuration.save"
const FILE_SCORE = "user://score.save"


func _ready():
	var file = File.new()
	if not file.file_exists(FILE_CONFIGURATION):
		save_data(file, true)
		load_data()
	else:
		load_data(file)
		
	file = File.new()
	if not file.file_exists(FILE_SCORE):
		save_score(file,true)
		load_score()
	else:
		load_score(file)
	

func add_input_event(action):	
	var event = InputEventKey.new()
	InputMap.action_erase_events(action)
	event.scancode = int(dict_param[action])
	InputMap.action_add_event(action, event)


func load_data(file_load = File.new()):
	file_load.open(FILE_CONFIGURATION, File.READ)
	dict_param = parse_json(file_load.get_line())
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
	file_load.close()


func load_score(file_load = File.new()):
	file_load.open(FILE_SCORE, File.READ)
	lst_score = parse_json(file_load.get_line())
	file_load.close()

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


func save_score(file_save = File.new(), default = false):
	var lst_save = [
		["Hercule Poivrot", 100000],
		["Henry Potier", 90000],
		["Martin Lepan", 80000],
		["René Dupont", 70000],
		["Louis Durant", 60000],
		["Harry Coverre", 50000],
		["Jean Bono", 40000],
		["Sarah Conord", 30000],
		["Jule César", 20000],
		["Gontrand Fromage", 10000],
		["Rogger Cartable", 9000],
		["Gorge Dubois", 8000],
		["Philibert Pimpaul", 7000],
		["Merphy Monkey", 6000],
		["Lorel Hardy", 5000],
		["Philips Siemens", 4000],
		["M Porpre", 3000],
		["Walter Canard", 2000],
		["Louis Vin", 1000],
	]
	file_save.open(FILE_SCORE, File.WRITE)
	file_save.store_line(to_json(lst_save if default else lst_score))
	file_save.close()


func can_add_score():
	for line_score in lst_score:
		if line_score[SCORE] < score:
			return true
	return false


func add_new_score(name):
	var index = 0
	for line_score in lst_score:
		if line_score[SCORE] < score:
			re_populate_score(index, name)
			break
		index  += 1


func re_populate_score(index, name):
	var lst_save = []
	
	for i in range(0, index):
		lst_save.append(lst_score[i])
	lst_save.append([name, score])
	for i in range(index, lst_score.size() - 1):
		lst_save.append(lst_score[i])
		
	lst_score = lst_save
	save_score()


func is_time_out():
	return time_left <= 0

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


func add_time_left_to_score():
	return time_left * 10


func reset_time():
	time_left = MAX_TIME_LEFT
	weapon = HAS_HAMMER


func restart():
	is_restart = true
	weapon = HAS_HAMMER
	life = 3
	cassoulet = 0
	score = 0
	time_left = MAX_TIME_LEFT

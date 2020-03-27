extends Node2D

signal score_changed(value)
signal life_changed(value, quantity)
signal cassoulet_changed(value, quantity)
signal time_decreases(value)

onready var coin_scene = preload("res://scene/item/coin.tscn")
onready var life_scene = preload("res://scene/item/life.tscn")
onready var cassoulet_scene = preload("res://scene/item/cassoulet.tscn")
onready var biboule_scene = preload("res://scene/character/biboule.tscn")
onready var pepito_scene = preload("res://scene/character/pepito.tscn")
onready var hitty_scene = preload("res://scene/character/hitty.tscn")
onready var walter_scene = preload("res://scene/character/walter.tscn")
onready var score_screen = preload("res://scene/item/score_screen.tscn")


export(String, FILE, "*.tscn") var next_right
export(String, FILE, "*.tscn") var next_left


var dict_scene
var go_next_scene = false

func _ready():
	dict_scene = {
		"coin": coin_scene,
		"life": life_scene,
		"cassoulet": cassoulet_scene,
		"pepito": pepito_scene,
		"biboule": biboule_scene,
		"walter": walter_scene,
		"hitty": hitty_scene,
	}

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	camera_set_limit()
	spawn_object($items, ["coin", "life", "cassoulet"], "picked")
	spawn_object($enemies, ["pepito", "biboule", "walter", "hitty"], "enemy_death")
	
	match GLOBAL.direction:
		GLOBAL.LEFT: 
			$player.global_position = $utils/spawn_right.global_position
		GLOBAL.RIGHT:
			$player.global_position = $utils/spawn_left.global_position
	
	GLOBAL.reset_time()


func _physics_process(delta):
	var cancel = Input.is_action_pressed("ui_cancel")
	if cancel:
		var menu = preload("res://scene/menu/menu_pause.tscn").instance()
		add_child(menu)

func camera_set_limit():
	var zone = $plateform.get_used_rect()
	var cells_size = $plateform.cell_size
	
	$player/cam.limit_left = zone.position.x * cells_size.x
	$player/cam.limit_top = zone.position.y * cells_size.y
	$player/cam.limit_right = (zone.size.x + zone.position.x) * cells_size.x
	$player/cam.limit_bottom = (zone.size.y + zone.position.y) * cells_size.y
	

func spawn_object(tile_map, list_name, signal_connect = ""):
	tile_map.hide()
	
	for cell in tile_map.get_used_cells():
		var id = tile_map.get_cellv(cell)
		var type = tile_map.tile_set.tile_get_name(id)
		if type in str(list_name):
			var pos = tile_map.map_to_world(cell)
			pos = pos + tile_map.position
			
			var itm = dict_scene[type].instance()
			if itm and itm.has_method("init"):
				itm.init(pos + tile_map.cell_size / 2, type)
				add_child(itm)
				if signal_connect == "picked":
					itm.connect(signal_connect, self, "_on_items_picked")
				elif signal_connect == "enemy_death":
					itm.connect(signal_connect, self, "_on_enemy_death")
				


func _on_enemy_death(value):
	emit_signal("score_changed", value)


func _on_items_picked(body, coin_value, quantity = 0):
	match body:
		"coin": emit_signal("score_changed", coin_value)
		"life": emit_signal("life_changed", coin_value, quantity)
		"cassoulet": emit_signal("cassoulet_changed", coin_value, quantity)
		

func _on_exit_right_body_entered(body):
	if body.name == "player" and next_right != null and not go_next_scene:
		go_next_scene = true
		GLOBAL.set_direction(GLOBAL.RIGHT)
		var score_time_left = GLOBAL.add_time_left_to_score()
		emit_signal("score_changed", score_time_left)
		var inst_score = score_screen.instance()
		add_child(inst_score)
		inst_score.start($player.global_position, score_time_left)
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene(next_right)
		queue_free()


func _on_exit_left_body_entered(body):
	pass


func _on_time_left_timeout():
	emit_signal("time_decreases", 1)
	if (GLOBAL.is_time_out()):
		$utils/time_left.stop()

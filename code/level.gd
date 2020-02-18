extends Node2D

signal score_changed(value)
signal life_changed(value)
signal cassoulet_changed(value)


onready var coin_scene = preload("res://scene/coin.tscn")
onready var life_scene = preload("res://scene/life.tscn")
onready var cassoulet_scene = preload("res://scene/cassoulet.tscn")
onready var biboule_scene = preload("res://scene/biboule.tscn")
onready var pepito_scene = preload("res://scene/pepito.tscn")
onready var hitty_scene = preload("res://scene/hitty.tscn")
onready var walter_scene = preload("res://scene/walter.tscn")


export(String, FILE, "*.tscn") var next_right
export(String, FILE, "*.tscn") var next_left


var dict_scene


func _ready():
	dict_scene = {
		"coin": coin_scene,
		"life": life_scene,
		"cassoulet": cassoulet_scene,
		"pepito": pepito_scene,
		"biboule": biboule_scene,
		"walter": walter_scene,
		"hitty": hitty_scene
	}

	camera_set_limit()
	spawn_object($items, ["coin", "life", "cassoulet"], "picked")
	spawn_object($enemies, ["pepito", "biboule", "walter", "hitty"])
	
	match GLOBAL.direction:
		GLOBAL.LEFT: 
			$player.global_position = $utils/spawn_right.global_position
		GLOBAL.RIGHT:
			$player.global_position = $utils/spawn_left.global_position


func _physics_process(delta):
	var cancel = Input.is_action_pressed("ui_cancel")
	if cancel:
		var menu = preload("res://scene/menu_pause.tscn").instance()
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
				if signal_connect != "":
					itm.connect(signal_connect, self, "_on_items_picked")
				

func _on_items_picked(body):
	match body:
		"coin": emit_signal("score_changed", 100)
		"life": emit_signal("life_changed", 1)
		"cassoulet": emit_signal("cassoulet_changed", 10)
		

func _on_exit_right_body_entered(body):
	if body.name == "player" and next_right != null:
		GLOBAL.set_direction(GLOBAL.RIGHT)
		get_tree().change_scene(next_right)


func _on_exit_left_body_entered(body):
	if body.name == "player" and next_left != null:
		GLOBAL.set_direction(GLOBAL.LEFT)
		get_tree().change_scene(next_left)


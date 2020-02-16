extends Node2D

onready var coin_scene = preload("res://scene/coin.tscn")
onready var life_scene = preload("res://scene/life.tscn")
onready var cassoulet_scene = preload("res://scene/cassoulet.tscn")
onready var biboule_scene = preload("res://scene/biboule.tscn")
onready var pepito_scene = preload("res://scene/pepito.tscn")
onready var hitty_scene = preload("res://scene/hitty.tscn")
onready var walter_scene = preload("res://scene/walter.tscn")

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
	spawn_object($items, ["coin", "life", "cassoulet"])
	spawn_object($enemies, ["pepito", "biboule", "walter", "hitty"])


func camera_set_limit():
	var zone = $plateform.get_used_rect()
	var cells_size = $plateform.cell_size
	
	$player/cam.limit_left = zone.position.x * cells_size.x
	$player/cam.limit_top = zone.position.y * cells_size.y
	$player/cam.limit_right = (zone.size.x + zone.position.x) * cells_size.x
	$player/cam.limit_bottom = (zone.size.y + zone.position.y) * cells_size.y
	

func spawn_object(tile_map, list_name):
	tile_map.hide()
	
	for cell in tile_map.get_used_cells():
		var id = tile_map.get_cellv(cell)
		var type = tile_map.tile_set.tile_get_name(id)
		if type in str(list_name):
			var pos = tile_map.map_to_world(cell)
			pos = pos + tile_map.position
			
			var itm = dict_scene[type].instance()
			if itm and itm.has_method("init"):
				itm.init(pos + tile_map.cell_size / 2)
				add_child(itm)
				

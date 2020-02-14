extends Node2D

onready var coin_scene = preload("res://scene/coin.tscn")
onready var life_scene = preload("res://scene/life.tscn")

func _ready():
	camera_set_limit()
	spawn_item()
	$items.hide()


func camera_set_limit():
	var zone = $plateform.get_used_rect()
	var cells_size = $plateform.cell_size
	
	$player/cam.limit_left = zone.position.x * cells_size.x
	$player/cam.limit_top = zone.position.y * cells_size.y
	$player/cam.limit_right = (zone.size.x + zone.position.x) * cells_size.x
	$player/cam.limit_bottom = (zone.size.y + zone.position.y) * cells_size.y
	

func spawn_item():
	for cell in $items.get_used_cells():
		var id = $items.get_cellv(cell)
		var type = $items.tile_set.tile_get_name(id)
		if type in ["coin", "life"]:
			var pos = $items.map_to_world(cell)
			pos = pos + $items.position
			
			var itm = null
			if type == "coin":
				itm = coin_scene.instance()
			else:
				itm = life_scene.instance()
				
			if itm and itm.has_method("init"):
				itm.init(pos + $items.cell_size / 2)
				add_child(itm)

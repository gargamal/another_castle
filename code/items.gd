extends Area2D


signal picked(body, coin_value, quantity)


var score_screen = preload("res://scene/item/score_screen.tscn")

var _type

export (int) var coin_life = 1000
export (int) var coin_cassoulet = 500
export (int) var coin = 100
export (int) var quantity_life = 1
export (int) var quantity_cassoulet = 10

var dict_data = {}

func _ready():
	dict_data = {
		"coin": [coin, 0],
		"life": [coin_life, quantity_life],
		"cassoulet": [coin_cassoulet, quantity_cassoulet]
	}


func init(pos, type):
	position = pos
	_type = type
		

func body_entered():
	var inst = score_screen.instance()
	get_parent().add_child(inst)
	inst.start(position, dict_data[_type][0])
	
	$Tween.interpolate_property(
		self, 
		"position", 
		position,
		Vector2(position.x, position.y - 300), 
		1,
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT)

	$Tween.interpolate_property(
		self, 
		"scale", 
		Vector2(1, 1),
		Vector2(0.5, 0.5), 
		1,
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT)
			
	$Tween.interpolate_property(
		self, 
		"modulate", 
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0), 
		0.5,
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT,
		0.5)
		
	$Tween.start()
	yield($Tween, "tween_completed")
	emit_signal("picked", _type, dict_data[_type][0], dict_data[_type][1])
	
	queue_free()


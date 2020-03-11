extends Node2D

var _type
var energy
var red = Color("#dbaa87")
var yellow = Color("#dbb387")

func init(pos, type):
	position = pos
	_type = type
	add_to_group("light", true)
	randomize()
	$light.color = yellow
	energy = $light.energy
	


func _physics_process(delta):
	var x = rand_range(0, 100)
	if x > 90:
		$light.energy = energy + rand_range(-0.02, 0.02)
		$light.color = yellow if $light.color == red else red

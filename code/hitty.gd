extends "res://code/enemy.gd"

func _ready():
	randomize()
	height_jump = 1000
	coin_value = 2000


func _on_delay_timeout():
	jump = int(rand_range(0, 10)) < 3

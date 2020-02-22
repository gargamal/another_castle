extends "res://code/enemy.gd"

func _ready():
	height_jump = 3000
	with_jump = true


func _on_delay_timeout():
	play_enemy()

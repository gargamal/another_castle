extends "res://code/ennemy.gd"

func _ready():
	height_jump = 3000

func _on_Timer_timeout():
	play_enemy()


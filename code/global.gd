extends Node


enum {LEFT, RIGHT, UP, DOWN}


var direction = RIGHT setget set_direction
var is_restart = false


func set_direction(dir):
	direction = dir

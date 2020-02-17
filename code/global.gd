extends Node


enum {LEFT, RIGHT, UP, DOWN}


var direction = RIGHT setget set_direction


func set_direction(dir):
	direction = dir

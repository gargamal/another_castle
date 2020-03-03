extends Node


enum {LEFT, RIGHT, UP, DOWN}


var direction = RIGHT setget set_direction
var is_restart = false


const LIFE_MAX = 10
var life
const CASSOULET_MAX = 100
var cassoulet
var score


enum {HAS_HAMMER, NO_HAMMER}
var weapon = HAS_HAMMER
enum {JEAN_BALAIS, SUPER_MARIOLLE}
var transformation = JEAN_BALAIS


func set_direction(dir):
	direction = dir


func is_super_mariolle():
	return transformation == SUPER_MARIOLLE


func is_jean_du_balais():
	return transformation == JEAN_BALAIS


func has_hammer():
	return weapon == HAS_HAMMER


func has_cassoulet():
	return cassoulet > 0

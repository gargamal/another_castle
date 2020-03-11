extends Node2D

var _type


func init(pos, type):
	position = pos
	_type = type
	add_to_group("light", true)
	$spot.visible = false

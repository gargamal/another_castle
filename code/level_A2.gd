extends "res://code/level.gd"

func _ready():
	$weather.active($weather.FOG)
	$weather.amount(5000, $weather.CAVERN)
	$weather.modulate(Color(1, 1, 1, 0.15), $weather.FOG)


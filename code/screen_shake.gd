extends Node2D


onready var camera = get_parent()
var old_position = Vector2()
var amplitude = 0

func start(p_amplitude, frequence, duration):
	randomize()
	old_position = camera.offset
	amplitude = p_amplitude
	$frequence.wait_time = duration / frequence
	$duration.wait_time = duration
	$frequence.start()
	$duration.start()
	shake(true)

func shake(activated):
	var position = Vector2()
	
	if not activated:
		position = old_position
	else:
		position = Vector2(rand_range(-amplitude, amplitude), rand_range(-amplitude, amplitude))

	$tween.interpolate_property(camera, "offset", camera.offset, position, $frequence.wait_time, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$tween.start()


func _on_duration_timeout():
	$frequence.stop()
	$duration.stop()
	shake(false)


func _on_frequence_timeout():
	shake(true)

extends Sprite

func init(pos, frame_number):
	position = pos
	frame = frame_number
	
	$anim.play("new")
	yield($anim, "animation_finished")
	queue_free()
	

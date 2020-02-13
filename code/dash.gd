extends Sprite

func init(pos, sprite):
	position = pos
	texture = sprite.texture
	flip_h = sprite.flip_h
	hframes = sprite.hframes
	vframes = sprite.vframes
	frame = sprite.frame
	
	$anim.play("new")
	yield($anim, "animation_finished")
	queue_free()
	

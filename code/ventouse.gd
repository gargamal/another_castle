extends KinematicBody2D

var speed = 1000
var vel = Vector2()

func ready():
	add_to_group("weapon")


func _physics_process(delta):
	var collision = move_and_collide(vel * delta)
	
	if collision:
		set_physics_process(false)
		if collision.collider.has_method("hit"):
			collision.collider.hit(10)
		$anim.play("touch")
		yield($anim, "animation_finished")
		queue_free()


func start(pos, dir):
	position = pos
	vel = Vector2(speed * dir, 0)
	$anim.play("shoot")
	$sprite.flip_h = (dir == -1)

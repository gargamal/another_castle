extends KinematicBody2D

var speed = 1000
var vel = Vector2()
var has_hitting = false
var is_on_floor = false

func _process(delta):
	var collision = move_and_collide(vel * delta, true, true, is_on_floor)
	if collision and not has_hitting:
		if collision.collider.has_method("hit"):
			collision.collider.hit(10)
		vel = Vector2(0, speed)
		has_hitting = true
	elif collision and has_hitting and not is_on_floor:
		vel = Vector2(0, 0)
		$anim.stop()
		is_on_floor = true
	elif collision and collision.collider.has_method("take_hammer"): 
			collision.collider.take_hammer()
			queue_free()



func start(pos, dir):
	position = pos
	vel = Vector2(speed * dir, 0)
	has_hitting = false
	is_on_floor = false
	$anim.play("turn")
	

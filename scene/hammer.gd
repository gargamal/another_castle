extends KinematicBody2D

const UP = Vector2(0, -1) # indique le plafond

var speed = 1000
var vel = Vector2()
var has_hitting = false
var is_on_floor = false
var pos_mem = Vector2(0, 0)

func _process(delta):
	var collision = move_and_collide(vel * delta, true, true, is_on_floor)
	move_and_slide(Vector2(0, 0), UP) # permet de fixer la normal et de connaitre la position du sol
	
	if collision and not has_hitting:
		if collision.collider.has_method("hit"):
			collision.collider.hit(10)
		vel = Vector2(0, speed)
		has_hitting = true
	elif collision and has_hitting and not is_on_floor:
		vel = Vector2(0, 0)
		$anim.stop()
		is_on_floor = true
	elif (collision and collision.collider.has_method("take_hammer")) \
		or (collision and collision.collider.name == "plateform" and pos_mem == position and not is_on_floor()): 
		get_parent().get_node("player").take_hammer()
		queue_free()
			
	pos_mem = position


func start(pos, dir):
	position = pos
	vel = Vector2(speed * dir, 0)
	has_hitting = false
	is_on_floor = false
	pos_mem = Vector2(0, 0)
	$anim.play("turn")
	

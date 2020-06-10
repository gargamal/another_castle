extends KinematicBody2D

const UP = Vector2(0, -1) # indique le plafond

var speed = 1000
var vel = Vector2()
var player

func ready():
	add_to_group("weapon")

func _physics_process(delta):
	var collision = move_and_collide(vel * delta, true, true, false)
	var _velocity = move_and_slide(Vector2(0, 0), UP) # permet de fixer la normal et de connaitre la position du sol
	
	if collision:
		set_physics_process(false)
		if collision.collider.has_method("hit"):
			collision.collider.hit(10)
		vel = Vector2(0, 0)
		$anim.play("touch")
		yield($anim, "animation_finished")
		player.take_hammer()
		queue_free()
		
	if player and is_not_on_limit(player.get_node("cam")):
		player.take_hammer()
		queue_free()


func is_not_on_limit(camera):
	return camera.limit_left >= position.x or camera.limit_right <= position.x \
		or camera.limit_top >= position.y or camera.limit_bottom <= position.y;


func start(pPlayer, pos, dir, diagonal):
	position = pos
	vel = Vector2(speed * dir, speed * diagonal)
	$anim.play("turn")
	player = pPlayer


func _on_touch_box_body_entered(body):
	if body.is_in_group("player"):
		body.take_hammer()
		queue_free()


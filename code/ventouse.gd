extends KinematicBody2D

var speed = 1000
var vel = Vector2()
var player

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
		
	if player and is_not_on_limit(player.get_node("cam")):
		queue_free()


func is_not_on_limit(camera):
	return camera.limit_left >= position.x or camera.limit_right <= position.x \
		or camera.limit_top >= position.y or camera.limit_bottom <= position.y;


func start(_player, pos, dir, diagonal):
	position = pos
	vel = Vector2(speed * dir, speed * diagonal)
	$anim.play("shoot")
	$sprite.flip_h = (dir == -1)
	$sprite.rotation_degrees = 45 * diagonal * dir
	player = _player

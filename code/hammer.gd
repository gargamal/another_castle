extends KinematicBody2D

const UP = Vector2(0, -1) # indique le plafond

var speed = 1000
var vel = Vector2()
var has_hitting = false
var is_fallen = false
var pos_mem = Vector2(0, 0)
var player

func ready():
	add_to_group("weapon")

func _physics_process(delta):
	var collision = move_and_collide(vel * delta, true, true, is_fallen)
	var error = move_and_slide(Vector2(0, 0), UP) # permet de fixer la normal et de connaitre la position du sol
	if error != OK: print("Failure code=" + error)	
	
	if collision:		
		if not has_hitting:
			if collision.collider.has_method("hit"):
				collision.collider.hit(10)
			vel = Vector2(0, speed)
			has_hitting = true
		elif has_hitting and not is_fallen:
			vel = Vector2(0, 0)
			$anim.stop()
			$sprite.frame = 2
			is_fallen = true
		elif collision.collider.name == "plateform" and pos_mem == position and not is_on_floor(): 
			player.take_hammer()
			queue_free()
			
	if player and is_not_on_limit(player.get_node("cam")):
		player.take_hammer()
		queue_free()
			
	pos_mem = position


func is_not_on_limit(camera):
	return camera.limit_left >= position.x or camera.limit_right <= position.x \
		or camera.limit_top >= position.y or camera.limit_bottom <= position.y;


func start(_player, pos, dir, diagonal):
	position = pos
	vel = Vector2(speed * dir, speed * diagonal)
	has_hitting = false
	is_fallen = false
	pos_mem = Vector2(0, 0)
	$anim.play("turn")
	player = _player


func _on_touch_box_body_entered(body):
	if body.is_in_group("player"):
		body.take_hammer()
		queue_free()


extends KinematicBody2D

const GRAVITY = 5000
const UP = Vector2(0, -1) # indique le plafond
const ACCEL = 100
const DASHING_FACTOR = 3
const LIMIT_LOW_SPEED = 5.0

var vel = Vector2()
var dir = 1
var dir_x
var has_hammer = true
# state
enum {IDLE, WALK, JUMP_UP, JUMP_DOWN, THROW, DEATH, DASH}
var state = IDLE
var dashing = false
var throwing = false
var throw_hammer = false

onready var hammer = preload("res://scene/hammer.tscn")
onready var img_dash = preload("res://scene/dash.tscn")

export (float) var dalay_time = 0.4
export (int) var height_jump = 1700
export (int) var max_speed = 400	

func _physics_process(delta):
	movement_loop()
	state_loop()
	vel.y += GRAVITY * delta
	vel = move_and_slide(vel, UP)
	

func animation_play(animation):
	if $anim.current_animation != animation:
		$anim.play(animation)


func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			animation_play("idle" if has_hammer else "idle_noham")
		WALK:
			animation_play("walk" if has_hammer else "walk_noham")
		JUMP_UP:
			animation_play("jump_up" if has_hammer else "jump_up_noham")
		JUMP_DOWN:
			animation_play("jump_down" if has_hammer else "jump_down_noham")
		DASH:
			for x in range(0, 5):
				var i = img_dash.instance()
				i.init(position, $sprite)
				get_parent().add_child(i)
				yield(get_tree().create_timer(0.05), "timeout")
				
			dashing = false
			change_state(IDLE)
		THROW:
			animation_play("throw_hammer")
			yield(get_tree().create_timer(0.2), "timeout")
			throwing = false
			
			var ham = hammer.instance()
			ham.start($muzzle.global_position, dir)
			get_parent().add_child(ham)
			has_hammer = false
			change_state(IDLE)
			

func state_loop():
	if state == IDLE and abs(vel.x) >= LIMIT_LOW_SPEED:
		change_state(WALK)
	if state == WALK and abs(vel.x) < LIMIT_LOW_SPEED:
		change_state(IDLE)
	if state in [IDLE, WALK] and not is_on_floor():
		change_state(JUMP_UP)
	if state == JUMP_UP and vel.y > 0:
		change_state(JUMP_DOWN)
	if state in [JUMP_DOWN, JUMP_UP] and is_on_floor():
		change_state(IDLE)
	if state == WALK and dashing:
		change_state(DASH)
	if throw_hammer and has_hammer and not throwing and not is_on_wall():
		change_state(THROW)

func movement_loop():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_just_pressed("ui_accept")
	var dash = Input.is_action_just_pressed("dash")
	throw_hammer = Input.is_action_just_pressed("ui_throw_hammer")

	if not dashing:
		dir_x = int(right) - int(left)
		
	if dash and state == WALK:
		dashing = true

	if dir_x == 1: # move right
		if state == DASH:
			vel.x = max_speed * DASHING_FACTOR
		else:
			vel.x = min(vel.x + ACCEL, max_speed)
		dir = 1
		$muzzle.position.x = 10
		$sprite.flip_h = false
	elif dir_x == -1: # move left
		if state == DASH:
			vel.x = -max_speed * DASHING_FACTOR
		else:
			vel.x = max(vel.x - ACCEL, -max_speed)
		dir = -1
		$muzzle.position.x = -90
		$sprite.flip_h = true
	else: # no move idle
		vel.x = lerp(vel.x, 0, 0.25)
		
	if jump and is_on_floor():
		vel.y = -height_jump
		
		
func take_hammer():
	has_hammer = true
	throwing = false
	change_state(IDLE)
	
	

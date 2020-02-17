extends KinematicBody2D


const GRAVITY = 5000
const UP = Vector2(0, -1) # indique le plafond
const ACCEL = 100
const LIMIT_LOW_SPEED = 5.0

var vel = Vector2()
var with_jump = true
var jump = false
var dir_x
var _type
# state
enum {IDLE, WALK, JUMP_UP, JUMP_DOWN, DEATH}
var state = IDLE

export (int) var height_jump = 1700
export (int) var max_speed = 400

func _ready():
	randomize()
	

func init(pos, type):
	position = pos
	_type = type
	

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
			animation_play("idle")
		WALK:
			animation_play("walk")
		JUMP_UP:
			animation_play("jump_up")
		JUMP_DOWN:
			animation_play("jump_down")
			

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
	

func movement_loop():
	if is_on_wall():
		dir_x = dir_x * -1
	
	if dir_x == 1: # move right
		vel.x = min(vel.x + ACCEL, max_speed)
		$sprite.flip_h = true
	elif dir_x == -1: # move left
		vel.x = max(vel.x - ACCEL, -max_speed)
		$sprite.flip_h = false
	else: # no move idle
		vel.x = lerp(vel.x, 0, 0.25)
		
	if jump and is_on_floor():
		vel.y = -height_jump
		jump = false
		
	
func play_enemy():
	var val = int(rand_range(0, 10))
	dir_x = 1 if val < 5 else -1 
	
	if with_jump:
		val = int(rand_range(0, 10))
		jump = val < 3
	

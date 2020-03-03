extends KinematicBody2D

const GRAVITY = 5000
const UP = Vector2(0, -1) # indique le plafond
const ACCEL = 100
const DASHING_FACTOR = 3
const LIMIT_LOW_SPEED = 5.0

var vel = Vector2()
var gravity = GRAVITY
var dir = 1
var dir_x

# state
enum {IDLE, WALK, JUMP_UP, JUMP_DOWN, THROW, DEATH, DASH, CASSOULET}
var state = IDLE
var dashing = false
var throwing = false
var throw_hammer = false
var is_hurting = false
var can_shoot_ventouse = true
var can_use_cassoulet = true
var cassoulet = false

onready var ventouse = preload("res://scene/ventouse.tscn")
onready var hammer = preload("res://scene/hammer.tscn")
onready var img_dash = preload("res://scene/dash.tscn")

var dalay_time = 0.4
var height_jump = 2000
var max_speed = 400

#SIGNALS
signal take_damage(value)
signal cassoulet_consume(quantity)


func _ready():
	add_to_group("player")


func _physics_process(delta):
	movement_loop()
	state_loop()
	vel.y += gravity * delta
	vel = move_and_slide(vel, UP)


func animation_play(animation, with_tranformation_state = false):
	if with_tranformation_state:
		if GLOBAL.is_super_mariolle():
			animation += "_mariolle"
		elif GLOBAL.is_jean_du_balais() and not GLOBAL.has_hammer():
			animation += "_noham"
	
	if $anim.current_animation != animation:
		$anim.play(animation)


func change_state(new_state):
	
	if state != new_state:
		state = new_state
		
		match state:
			IDLE: animation_play("idle", true)
			WALK: animation_play("walk", true)
			JUMP_UP: animation_play("jump_up", true)
			JUMP_DOWN: animation_play("jump_down", true)
			DASH:
				for x in range(0, 5):
					var i = img_dash.instance()
					i.init(position, $sprite)
					get_parent().add_child(i)
					yield(get_tree().create_timer(0.05), "timeout")
					
				dashing = false
				change_state(IDLE)
			THROW:
				if GLOBAL.is_super_mariolle():
					play_ventouse_animation()
				else:
					play_hammer_animation()
					throwing = false
					GLOBAL.weapon = GLOBAL.NO_HAMMER
				change_state(IDLE)
			DEATH:
				set_physics_process(false)
				animation_play("death")
			CASSOULET:
				emit_signal("cassoulet_consume", 10)
				animation_play("cassoulet_effect", true)
				$delay_cassoulet.start()


func play_ventouse_animation():
	if can_shoot_ventouse:
		can_shoot_ventouse = false
		var vent = ventouse.instance()
		vent.start($muzzle.global_position, dir)
		get_parent().add_child(vent)
		$delay_shoot.start()


func play_hammer_animation():
	animation_play("throw_hammer")
	yield(get_tree().create_timer(0.2), "timeout")
	
	var ham = hammer.instance()
	ham.start($muzzle.global_position, dir)
	get_parent().add_child(ham)


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
	if GLOBAL.is_jean_du_balais() and throw_hammer and GLOBAL.has_hammer() and not throwing and not is_on_wall():
		change_state(THROW)
	if GLOBAL.is_super_mariolle() and throw_hammer:
		change_state(THROW)
	if gravity == 0 and GLOBAL.has_cassoulet() and can_use_cassoulet:
		change_state(CASSOULET)


func movement_loop():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var jump = Input.is_action_just_pressed("ui_accept")
	var dash = Input.is_action_just_pressed("dash")
	throw_hammer = Input.is_action_just_pressed("ui_throw_hammer")
	cassoulet = Input.is_action_just_pressed("ui_cassoulet")

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
		$muzzle.position.x = 0 if GLOBAL.is_jean_du_balais() else 60
		$sprite.flip_h = false
	elif dir_x == -1: # move left
		if state == DASH:
			vel.x = -max_speed * DASHING_FACTOR
		else:
			vel.x = max(vel.x - ACCEL, -max_speed)
		dir = -1
		$muzzle.position.x = -160 if GLOBAL.is_jean_du_balais() else -60
		$sprite.flip_h = true
	else: # no move idle
		vel.x = lerp(vel.x, 0, 0.25)
		
	if jump and is_on_floor():
		vel.y = -height_jump
		
	if cassoulet and GLOBAL.has_cassoulet() and can_use_cassoulet:
		gravity = 0
		
	if gravity == 0 and down :
		vel.y =  min(vel.y + ACCEL, max_speed)
	if gravity == 0 and up :
		vel.y = max(vel.y - ACCEL, -max_speed)
	if gravity == 0 and not down and not up:
		vel.y = lerp(vel.y, 0, 0.25)
		
func take_hammer():
	GLOBAL.weapon = GLOBAL.HAS_HAMMER
	throwing = false
	change_state(IDLE)


func _on_hit_box_body_entered(body):
	if body.is_in_group("enemy") and not is_hurting and state != DEATH:
		emit_signal("take_damage", body.damage)
		$cam/screen_shake.start(20, 5, 0.2)
		is_hurting = true
		var collision_point = global_position - body.global_position
		vel.x = sign(collision_point.x) * (max_speed * 4)
		vel.y = -(height_jump / 2)
		vel = move_and_slide(vel, UP)
		for i in range(0, 9):
			yield(get_tree().create_timer(0.2), "timeout")
			modulate = Color(1, 1, 1, 0.8 if i % 2 == 0 else 0.2)
		modulate = Color(1, 1, 1, 1)
		is_hurting = false


func _on_HUD_death_player():
	change_state(DEATH)


func _on_HUD_transform_jean_balais():
	if GLOBAL.is_super_mariolle():
		GLOBAL.transformation = GLOBAL.JEAN_BALAIS
		animation_play("transform_to_jean_balais_noham" if not GLOBAL.has_hammer() else "transform_to_jean_balais")
		yield(get_tree().create_timer(0.2), "timeout")
		change_state(IDLE)


func _on_HUD_transform_super_mariolle():
	if GLOBAL.is_jean_du_balais():
		GLOBAL.transformation = GLOBAL.SUPER_MARIOLLE
		animation_play("transform_to_mariolle")
		yield(get_tree().create_timer(0.2), "timeout")
		change_state(IDLE)


func _on_delay_shoot_timeout():
	can_shoot_ventouse = true


func _on_delay_cassoulet_timeout():
	can_use_cassoulet = true
	gravity = GRAVITY
	change_state(IDLE)

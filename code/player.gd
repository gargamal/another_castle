extends KinematicBody2D

const GRAVITY = 5000
const UP = Vector2(0, -1) # indique le plafond
const ACCEL = 100
const DASHING_FACTOR = 5
const LIMIT_LOW_SPEED = 10.0
const LIMIT_LOW_FALL = 250.0

var vel = Vector2()
var gravity = GRAVITY
var dir = 1
var dir_x
var dir_y

# state
enum {IDLE, WALK, JUMP_UP, JUMP_DOWN, THROW, DEATH, DASH, CASSOULET, TRANSFORM_JEAN_DU_BALAIS, TRANSFORM_SUPER_MARIOLLE}
var state = IDLE
var dashing = false
var throw_hammer = false
var is_hurting = false
var can_shoot_ventouse = true
var can_use_cassoulet = true
var cassoulet = false

onready var ventouse = preload("res://scene/item/ventouse.tscn")
onready var hammer = preload("res://scene/item/hammer.tscn")
onready var img_dash = preload("res://scene/item/dash.tscn")

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
	
	var space_state := get_world_2d().direct_space_state
	var result := space_state.intersect_ray(global_position, global_position + Vector2.DOWN * 128, [self])
	
	if result:
		vel = vel - result.normal * gravity * delta
	else: 
		vel.y += gravity * delta
		
	vel = move_and_slide(vel, UP)


func animation_play(animation, with_tranformation_state = false):
	if with_tranformation_state:
		if GLOBAL.is_super_mariolle():
			animation += "_mariolle"
		elif GLOBAL.is_jean_du_balais() and not GLOBAL.has_hammer():
			animation += "_noham"
	
	if $anim.current_animation != animation:
		$anim.current_animation = animation
		$anim.play(animation)


func change_state(new_state):
	state = new_state
	match state:
		IDLE: animation_play("idle", true)
		WALK: animation_play("walk", true)
		JUMP_UP: animation_play("jump_up", true)
		JUMP_DOWN: animation_play("jump_down", true)
		DASH:
			for _x in range(0, 5):
				var i = img_dash.instance()
				i.init(position, 17)
				get_parent().add_child(i)
				yield(get_tree().create_timer(0.05), "timeout")
				
			dashing = false
			change_state(IDLE)
		THROW:
			if GLOBAL.is_super_mariolle():
				play_ventouse_animation()
			else:
				play_hammer_animation()
				GLOBAL.weapon = GLOBAL.NO_HAMMER
		DEATH:
			set_physics_process(false)
			animation_play("death")
		CASSOULET:
			if cassoulet:
				emit_signal("cassoulet_consume", 10)
				GLOBAL.nb_tick_cassoulet = GLOBAL.MAX_TICK_CASSOULET
				$delay_cassoulet.start()
			animation_play("cassoulet_effect", true)
		TRANSFORM_SUPER_MARIOLLE:
			GLOBAL.transformation = GLOBAL.SUPER_MARIOLLE
			animation_play("transform_to_mariolle")
			yield(get_tree().create_timer(0.2), "timeout")
			change_state(IDLE)
		TRANSFORM_JEAN_DU_BALAIS:
			GLOBAL.transformation = GLOBAL.JEAN_BALAIS
			animation_play("transform_to_jean_balais_noham" if not GLOBAL.has_hammer() else "transform_to_jean_balais")
			yield(get_tree().create_timer(0.2), "timeout")
			change_state(IDLE)


func play_ventouse_animation():
	if can_shoot_ventouse:
		can_shoot_ventouse = false
		
		animation_play("throw_ventouse_cassoulet" if gravity == 0 else "throw_ventouse")
		yield(get_tree().create_timer(0.1), "timeout")
		
		var vent = ventouse.instance()
		vent.start(self, $muzzle.global_position, dir, dir_y)
		get_parent().add_child(vent)
		$delay_shoot.start()
		
	change_state(IDLE)


func play_hammer_animation():
	animation_play("throw_hammer_cassoulet" if gravity == 0 else "throw_hammer" )
	yield(get_tree().create_timer(0.1), "timeout")
	
	var ham = hammer.instance()
	ham.start(self, $muzzle.global_position, dir, dir_y)
	get_parent().add_child(ham)
	
	change_state(IDLE)


func state_loop():
	if  gravity > 0:
		if state == IDLE and abs(vel.x) >= LIMIT_LOW_SPEED:
			change_state(WALK)
		if state == WALK and abs(vel.x) < LIMIT_LOW_SPEED:
			change_state(IDLE)
		if state in [IDLE, WALK] and not is_on_floor():
			change_state(JUMP_UP)
		if state == JUMP_UP and vel.y > LIMIT_LOW_FALL:
			change_state(JUMP_DOWN)
		if state in [JUMP_DOWN, JUMP_UP] and is_on_floor():
			change_state(IDLE)
		if state == WALK and dashing:
			change_state(DASH)
	elif state == IDLE or GLOBAL.has_cassoulet() and can_use_cassoulet:
		change_state(CASSOULET)
	
	if GLOBAL.is_jean_du_balais() and throw_hammer and GLOBAL.has_hammer() and not is_on_wall():
		change_state(THROW)
	if GLOBAL.is_super_mariolle() and throw_hammer:
		change_state(THROW)


func movement_loop():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var jump = Input.is_action_just_pressed("ui_jump")
	var dash = Input.is_action_just_pressed("ui_dash")
	throw_hammer = Input.is_action_just_pressed("ui_throw_hammer")
	cassoulet = Input.is_action_just_pressed("ui_cassoulet")

	if not dashing:
		dir_x = int(right) - int(left)
		
	dir_y = int(down) - int(up)
		
	if dash and state == WALK:
		dashing = true

	if dir_x == 1: # move right
		if state == DASH:
			vel.x = max_speed * DASHING_FACTOR
		else:
			vel.x = min(vel.x + ACCEL, max_speed)
		dir = 1
		$muzzle.position.x = abs($muzzle.position.x)
		$sprite.flip_h = false
	elif dir_x == -1: # move left
		if state == DASH:
			vel.x = -max_speed * DASHING_FACTOR
		else:
			vel.x = max(vel.x - ACCEL, -max_speed)
		dir = -1
		$muzzle.position.x = -abs($muzzle.position.x)
		$sprite.flip_h = true
	else: # no move idle
		vel.x = lerp(vel.x, 0, 0.4)
		
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
		change_state(TRANSFORM_JEAN_DU_BALAIS)


func _on_HUD_transform_super_mariolle():
	if GLOBAL.is_jean_du_balais():
		change_state(TRANSFORM_SUPER_MARIOLLE)
		

func _on_delay_shoot_timeout():
	can_shoot_ventouse = true


func _on_delay_cassoulet_timeout():
	GLOBAL.nb_tick_cassoulet -= 1
	if GLOBAL.nb_tick_cassoulet <= 0:
		$delay_cassoulet.stop()
		can_use_cassoulet = true
		gravity = GRAVITY
		change_state(IDLE)

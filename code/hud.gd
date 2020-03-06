extends Control

const COLOR_PAIR = Color(1, 0, 0, 0.8)
const COLOR_IMPAIR = Color(0, 1, 0, 0.2)
const WHITE = Color(1, 1, 1, 1)

var arrow = load("res://img/cursor/arrow.png")
var beam = load("res://img/cursor/beam.png")

#SIGNAL
signal death_player()
signal transform_super_mariolle()
signal transform_jean_balais()

func _ready():
	Engine.time_scale = 1.0
	Input.set_custom_mouse_cursor(arrow)
	Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if GLOBAL.life == GLOBAL.LIFE_MAX:
		emit_signal("transform_super_mariolle")
	else:
		emit_signal("transform_jean_balais")


func _process(delta):
	$canvas/vb/hb_life/life.value = GLOBAL.life
	$canvas/vb/hb_cassoulet/cassoulet.value = (GLOBAL.cassoulet + 9) / 10
	$canvas/vb/hb_score/score.text = str(GLOBAL.score)
	$canvas/vb/hb_time/time.text = str(GLOBAL.time_left)


func _on_enemy_death(value):
	add_score(value)


func _on_level_cassoulet_changed(value, quantity):
	add_cassoulet(quantity)
	add_score(value)


func _on_player_cassoulet_consume(quantity):
	add_cassoulet(-quantity)


func _on_level_life_changed(value, quantity):
	add_life(quantity)
	add_score(value)


func _on_level_score_changed(value):
	add_score(value)


func add_score(value):
	GLOBAL.score += value
	for i in range(0, 5):
		$canvas/vb/hb_score/score.modulate = COLOR_PAIR if i % 2 else COLOR_IMPAIR
		yield(get_tree().create_timer(0.2), "timeout")
	$canvas/vb/hb_score/score.modulate = WHITE


func play_game_over():
	emit_signal("death_player")
	Engine.time_scale = 0.5
	$canvas/anim.play("game_over")
	yield($canvas/anim, "animation_finished")
	if GLOBAL.can_add_score():
		$canvas/background/vb_gameover/gameover.visible = true
		$canvas/background/vb_gameover/titlename.visible = true
		$canvas/background/vb_gameover/ok.visible = true
		$canvas/background/vb_gameover/name.visible = true
		$canvas/background/vb_gameover/name.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		get_tree().reload_current_scene()


func _on_player_take_damage(value):
	add_life(-value)
	if GLOBAL.life <= 0:
		play_game_over()


func add_life(value):
	GLOBAL.life = min(GLOBAL.life + value, GLOBAL.LIFE_MAX)
	
	if GLOBAL.life == GLOBAL.LIFE_MAX:
		emit_signal("transform_super_mariolle")
	else:
		emit_signal("transform_jean_balais")
		for i in range(0, 5):
			$canvas/vb/hb_life/life.modulate = COLOR_PAIR if i % 2 else COLOR_IMPAIR
			yield(get_tree().create_timer(0.2), "timeout")
		$canvas/vb/hb_life/life.modulate = WHITE


func add_cassoulet(value):
	GLOBAL.cassoulet = min(GLOBAL.cassoulet + value, GLOBAL.CASSOULET_MAX)
	
	if GLOBAL.cassoulet < GLOBAL.CASSOULET_MAX:
		for i in range(0, 5):
			$canvas/vb/hb_cassoulet/cassoulet.modulate = COLOR_PAIR if i % 2 else COLOR_IMPAIR
			yield(get_tree().create_timer(0.2), "timeout")
		$canvas/vb/hb_cassoulet/cassoulet.modulate = WHITE


func _on_level_time_decreases(value):
	GLOBAL.time_left -= value
	if GLOBAL.time_left <= 0:
		play_game_over()
	elif GLOBAL.time_left <= 20:
		for i in range(0, 4):
			$canvas/vb/hb_time/time.modulate = COLOR_PAIR if i % 2 else COLOR_IMPAIR
			yield(get_tree().create_timer(0.2), "timeout")
		$canvas/vb/hb_time/time.modulate = WHITE


func _on_ok_pressed():
	var user_name = $canvas/background/vb_gameover/name.text
	GLOBAL.add_new_score("empty" if not user_name or user_name == "" else user_name)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$canvas/background/vb_gameover/gameover.visible = false
	$canvas/background/vb_gameover/titlename.visible = false
	$canvas/background/vb_gameover/ok.visible = false
	$canvas/background/vb_gameover/name.visible = false
	get_tree().reload_current_scene()

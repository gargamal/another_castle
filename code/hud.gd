extends Control

var life
var life_max = 10
var cassoulet
var cassoulet_max = 100
var score

const COLOR_PAIR = Color(1, 0, 0, 0.8)
const COLOR_IMPAIR = Color(0, 1, 0, 0.2)
const WHITE = Color(1, 1, 1, 1)

#SIGNAL
signal death_player


func _ready():
	life = 3
	cassoulet = 0
	score = 0
	Engine.time_scale = 1.0


func _process(delta):
	$canvas/vb/hb_life/life.value = life
	$canvas/vb/hb_cassoulet/cassoulet.value = (cassoulet + 9) / 10
	$canvas/vb/hb_score/score.text = str(score)


func _on_enemy_death(value):
	add_score(value)


func _on_level_cassoulet_changed(value, quantity):
	add_cassoulet(quantity)
	add_score(value)


func _on_level_life_changed(value, quantity):
	add_life(quantity)
	add_score(value)


func _on_level_score_changed(value):
	add_score(value)

func add_score(value):
	score += value
	for i in range(0, 5):
		$canvas/vb/hb_score/score.modulate = COLOR_PAIR if i % 2 else COLOR_IMPAIR
		yield(get_tree().create_timer(0.2), "timeout")
	$canvas/vb/hb_score/score.modulate = WHITE


func _on_player_take_damage(value):
	add_life(-life)
	if life <= 0:
		emit_signal("death_player")
		Engine.time_scale = 0.5
		$CanvasLayer/AnimationPlayer.play("game_over")


func add_life(value):
	life = min(life + value, life_max)
	for i in range(0, 5):
		$canvas/vb/hb_life/life.modulate = COLOR_PAIR if i % 2 else COLOR_IMPAIR
		yield(get_tree().create_timer(0.2), "timeout")
	$canvas/vb/hb_life/life.modulate = WHITE


func add_cassoulet(value):
	cassoulet = min(cassoulet + value, cassoulet_max)
	for i in range(0, 5):
		$canvas/vb/hb_cassoulet/cassoulet.modulate = COLOR_PAIR if i % 2 else COLOR_IMPAIR
		yield(get_tree().create_timer(0.2), "timeout")
	$canvas/vb/hb_cassoulet/cassoulet.modulate = WHITE


func _on_Button_pressed():
	get_tree().reload_current_scene()


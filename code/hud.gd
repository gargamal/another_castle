extends Control

var life
var life_max = 10
var cassoulet
var cassoulet_max = 100
var score


#SIGNAL
signal death_player


func _ready():
	life = 3
	cassoulet = 0
	score = 0
	Engine.time_scale = 1.0


func _process(delta):
	$CanvasLayer/VBoxContainer/HBoxContainer/life.value = life
	$CanvasLayer/VBoxContainer/HBoxContainer2/cassoulet.value = (cassoulet + 9) / 10
	$CanvasLayer/VBoxContainer/HBoxContainer3/score.text = str(score)


func _on_enemy_death(value):
	score += value


func _on_level_cassoulet_changed(value):
	cassoulet = min(cassoulet +  value, cassoulet_max)


func _on_level_life_changed(value):
	life = min(life + value, life_max)


func _on_level_score_changed(value):
	score += value


func _on_player_take_damage(value):
	life -= value
	if life <= 0:
		emit_signal("death_player")
		Engine.time_scale = 0.5
		$CanvasLayer/AnimationPlayer.play("game_over")


func _on_Button_pressed():
	get_tree().reload_current_scene()


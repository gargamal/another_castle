extends Control

var life
var life_max = 10
var cassoulet
var cassoulet_max = 100
var score


func _ready():
	life = 3
	cassoulet = 0
	score = 0


func _process(delta):
	$CanvasLayer/VBoxContainer/HBoxContainer/life.value = life
	$CanvasLayer/VBoxContainer/HBoxContainer2/cassoulet.value = (cassoulet + 9) / 10
	$CanvasLayer/VBoxContainer/HBoxContainer3/score.text = str(score)



func _on_level_A1_cassoulet_changed(value):
	cassoulet = min(cassoulet +  value, cassoulet_max)


func _on_level_A1_life_changed(value):
	life = min(life + value, life_max)


func _on_level_A1_score_changed(value):
	score += value


extends Node2D


func start(p_position, score):
	position = p_position
	$Label.text = str(score)
	
	$Tween.interpolate_property(
		self, 
		"position", 
		Vector2(position.x - 32, position.y - 32),
		Vector2(position.x - 96, position.y - 150), 
		1,
		Tween.TRANS_SINE, 
		Tween.EASE_IN_OUT)

	$Tween.interpolate_property(
		self, 
		"scale", 
		Vector2(1, 1),
		Vector2(0.5, 0.5), 
		1,
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT)
			
	$Tween.interpolate_property(
		self, 
		"modulate", 
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0), 
		0.8,
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT,
		0.5)
		
	$Tween.start()
	yield($Tween, "tween_completed")
	
	queue_free()



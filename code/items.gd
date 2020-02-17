extends Area2D


signal picked(body)

var _type

func init(pos, type):
	position = pos
	_type = type
		

func body_entered():
	$Tween.interpolate_property(
		self, 
		"position", 
		position,
		Vector2(position.x, position.y - 300), 
		1,
		Tween.TRANS_BACK, 
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
		0.5,
		Tween.TRANS_BACK, 
		Tween.EASE_IN_OUT,
		0.5)
		
	$Tween.start()
	yield($Tween, "tween_completed")
	emit_signal("picked", _type)
	
	queue_free()


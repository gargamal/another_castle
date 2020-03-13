extends CanvasLayer


enum { SUN, RAIN, SNOW }


func _ready():
	set_weather(0, SUN)


func set_weather(amount, weather):
	match(weather):
		SUN:
			$rain.emitting = false
			$snow.emitting = false
		RAIN:
			$rain.emitting = true
			$snow.emitting = false
			$rain.amount = amount
		SNOW:
			$rain.emitting = false
			$snow.emitting = true
			$snow.amount = amount

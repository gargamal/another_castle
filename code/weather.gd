extends CanvasLayer


enum { SUN, RAIN, SNOW, CAVERN }


func _ready():
	set_weather(0, SUN)


func set_weather(amount, weather):
	match(weather):
		SUN:
			$rain.emitting = false
			$snow.emitting = false
			$cavern.emitting = false
		RAIN:
			$rain.emitting = true
			$snow.emitting = false
			$cavern.emitting = false
			$rain.amount = amount
		SNOW:
			$rain.emitting = false
			$snow.emitting = true
			$cavern.emitting = false
			$snow.amount = amount
		CAVERN:
			$rain.emitting = false
			$snow.emitting = false
			$cavern.emitting = true
			$cavern.amount = amount

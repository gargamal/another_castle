extends CanvasLayer


enum { SUN, RAIN, SNOW, CAVERN, FOG }


func _ready():
	sun()


func sun():
	$rain.emitting = false
	$snow.emitting = false
	$cavern.emitting = false
	$fog.emitting = true


func active_default(weather):
	match(weather):
		RAIN:
			$rain.emitting = true
		SNOW:
			$snow.emitting = true
		CAVERN:
			$cavern.emitting = true
		FOG:
			$fog.emitting = true
	
	print ($rain.emitting)


func active(amount, weather):
	match(weather):
		RAIN:
			$rain.emitting = true
			$rain.amount = amount
		SNOW:
			$snow.emitting = true
			$snow.amount = amount
		CAVERN:
			$cavern.emitting = true
			$cavern.amount = amount
		FOG:
			$fog.emitting = true
			$fog.amount = amount


func desactive(weather):
	match(weather):
		RAIN:
			$rain.emitting = false
		SNOW:
			$snow.emitting = false
		CAVERN:
			$cavern.emitting = false
		FOG:
			$fog.emitting = false

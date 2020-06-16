extends CanvasLayer


enum { SUN, RAIN, SNOW, CAVERN, FOG }


func _ready():
	sun()


func sun():
	$rain.emitting = false
	$snow.emitting = false
	$cavern.emitting = false
	$fog.emitting = false


func active(weather):
	match(weather):
		RAIN:
			$rain.emitting = true
		SNOW:
			$snow.emitting = true
		CAVERN:
			$cavern.emitting = true
		FOG:
			$fog.emitting = true

func amount(amount, weather):
	match(weather):
		RAIN:
			$rain.amount = amount
		SNOW:
			$snow.amount = amount
		CAVERN:
			$cavern.amount = amount
		FOG:
			$fog.amount = amount

func modulate(modulate, weather):
	match(weather):
		RAIN:
			$rain.modulate = modulate
		SNOW:
			$snow.modulate = modulate
		CAVERN:
			$cavern.modulate = modulate
		FOG:
			$fog.modulate = modulate


func speed(velocity, radial_accel, radial_accel_random, lifetime, weather):
	var weather_inst = null
	
	match(weather):
		RAIN:
			weather_inst = $rain
		SNOW:
			weather_inst = $snow
		CAVERN:
			weather_inst = $cavern
		FOG:
			weather_inst = $fog
			
	if weather_inst:
		weather_inst.process_material["initial_velocity"] = velocity
		weather_inst.process_material["radial_accel"] = radial_accel
		weather_inst.process_material["radial_accel_random"] = radial_accel_random
		weather_inst.lifetime = lifetime
		weather_inst.preprocess = lifetime


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

extends Node2D

func _physics_process(delta: float) -> void:
	if $Ray.is_colliding():

		$ReflectedCast.enabled = true
		$ReflectedCast.global_position = $Ray.get_collision_point()

		$ReflectedCast.cast_to = $Ray.cast_to.reflect($Ray.get_collision_normal())
		$ReflectedCast.add_exception($Ray.get_collider())

	else:
		$ReflectedCast.enabled = false

	if $ReflectedCast.is_colliding():
			found_area()

func found_area():
	print(str(OS.get_system_time_secs()) + "  BOOM FOUND LIGHT SENSOR")

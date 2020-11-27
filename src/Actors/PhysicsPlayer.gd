extends PhysicsActor

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

var direction = get_direction()

var velocity

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	velocity = state.linear_velocity

	direction = get_direction()
	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y < 0.0
	state.linear_velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if direction.x != 0:
		sprite.scale.x = direction.x

	var animation = get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)


func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x

	if direction.y != 0.0:
		apply_central_impulse(speed.y * direction.y)
	if is_jump_interrupted:
		velocity.y = 0.0

	if in_antigravity:
		if antigravity_direction == "right":
			velocity = Vector2(speed.x, 0)
		elif antigravity_direction == "left":
			velocity = Vector2(-speed.x, 0)

	return velocity


func get_new_animation():
	var animation_new = ""
	if is_on_floor():
		animation_new = "walk" if abs(velocity.x) > 0.1 else "idle"
	else:
		animation_new = "fall" if velocity.y > 0 else "jump"
	return animation_new


func is_on_floor():
	for b in get_colliding_bodies():
		return "StaticBody2D" in b.name

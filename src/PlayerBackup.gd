extends KinematicBody2D

# Where we define the floor to be
const FLOOR_NORMAL: = Vector2.UP

# Speed
export var speed := Vector2(150, 0)
export var jump_speed = -1500
export var gravity: = 4500

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity: = Vector2.ZERO
var anim := ""


func get_input():
	var dir = 0
	if Input.is_action_pressed("move_right"):
		dir += 1
	if Input.is_action_pressed("move_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed.x, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta: float) -> void:
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed #* Input.get_action_strength("jump")
			print(velocity)

	animate_player()

func animate_player() -> void:

	# Default new anim
	var new_anim := "idle"

	if is_on_floor():
		# If they hit the ground after falling, play the hit_ground animation
		# But it won't do this if they land in water; the swim animation will play then
		if anim == "fall":
			$AnimationPlayer.play("hit_ground")
			yield($AnimationPlayer, "animation_finished")


		# Flip the sprite horizontally if they're moving left
		if velocity.x < -1:
			$Sprite.set_flip_h(true)
			new_anim = "walk"

		# Undo any existing flip if they're moving to the right
		if velocity.x > 1:
			$Sprite.set_flip_h(false)
			new_anim = "walk"
	else:
		# If they're going up, set the jumping animation
		# Otherwise, set the fall animation
		if velocity.y < -1:
			new_anim = "jump"
		else:
			new_anim = "fall"

	# Play the new animation if it's different
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)

#func kill_player():
#	# Set a global variable, and remove any powerups they've gained this level
##	Globals.player_died = true
#
#	# Stop mvovement
#	set_physics_process(false)
#
#	# Play death anim
#	$AnimationPlayer.play("death")
#	yield($AnimationPlayer, "animation_finished")
#	$AnimationPlayer.stop(true)
#
#	# Wait for 0.25s
#	yield(get_tree().create_timer(0.25), "timeout")
#
#	# Reload scene
#	get_tree().reload_current_scene()

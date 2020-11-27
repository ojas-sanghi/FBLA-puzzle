class_name PhysicsObject
extends RigidBody2D

func _ready() -> void:
	Signals.connect("entered_antigravity", self, "_on_entered_antigravity")
	Signals.connect("exited_antigravity", self, "_on_exited_antigravity")
	can_sleep = false

func _on_entered_antigravity(direction: String, body: Node):
	if self != body:
		return
	match direction:
		"up":
			linear_velocity.y = 0
			gravity_scale = -1
		"down":
			linear_velocity.y = 0
			gravity_scale = 1
		"left":
			linear_velocity.y = 0
			applied_force = Vector2(-150, 0)
#			linear_velocity = Vector2(-150, 0)
			gravity_scale = 0
		"right":
			linear_velocity.y = 0
			applied_force = Vector2(150, 0)
#			linear_velocity = Vector2(150, 0)
			gravity_scale = 0

func _on_exited_antigravity(body: Node):
	if self != body:
		return
	applied_force = Vector2(0, 0)
	gravity_scale = 1

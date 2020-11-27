class_name PhysicsActor
extends RigidBody2D

export var speed = Vector2(400.0, 700.0)

var in_antigravity := false
var antigravity_direction := ""

func _ready() -> void:
	Signals.connect("entered_antigravity", self, "_on_entered_antigravity")
	Signals.connect("exited_antigravity", self, "_on_exited_antigravity")


func _on_entered_antigravity(direction: String, body: Node):
	if self != body:
		return
	in_antigravity = true
	antigravity_direction = direction

func _on_exited_antigravity(body: Node):
	if self != body:
		return
	in_antigravity = false
	antigravity_direction = ""

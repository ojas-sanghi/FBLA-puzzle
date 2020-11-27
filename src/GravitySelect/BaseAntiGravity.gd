extends Area2D

export var direction := 'up'

func _ready() -> void:
	match direction:
		"up":
			$Particles2D.rotation_degrees = -180
		"down":
			$Particles2D.rotation_degrees = 0
		"left":
			$Particles2D.rotation_degrees = -270
		"right":
			$Particles2D.rotation_degrees = -90

# pass direction to change gravity
# pass body so that those listening can check if *they* are in anti gravity
func _on_BaseAntiGravity_body_entered(body: Node) -> void:
	Signals.emit_signal("entered_antigravity", direction, body)

func _on_BaseAntiGravity_body_exited(body: Node) -> void:
	Signals.emit_signal("exited_antigravity", body)

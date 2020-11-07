extends RigidBody2D

signal clicked

var held = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			held = true
		if !event.pressed:
			held = false

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()

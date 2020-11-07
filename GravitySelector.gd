extends Control

func _on_Up_pressed() -> void:
	Signals.emit_signal("gravity_selected", "up")


func _on_Right_pressed() -> void:
	Signals.emit_signal("gravity_selected", "right")


func _on_Down_pressed() -> void:
	Signals.emit_signal("gravity_selected", "down")


func _on_Left_pressed() -> void:
	Signals.emit_signal("gravity_selected", "left")

extends Node2D

var dragging = false  # Are we currently dragging?
var drawing_paused = false
var selection_outline
var selector_button

var drag_start: Vector2  # Location where drag began.
var drag_end: Vector2 # Location where drag ended

var base_anti_gravity = preload("res://src/GravitySelect/BaseAntiGravity.tscn")

func _ready() -> void:
	Signals.connect("gravity_selected", self, "make_area")

func _unhandled_input(event: InputEvent) -> void:
	# code to draw selector rectangle
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			drag_start = event.position

			dragging = true
			# if there was already a drawing, get rid of the pre-existing gravity selector
			if drawing_paused and selector_button:
				selector_button.queue_free()
			drawing_paused = false

		# Button released while dragging.
		elif dragging:
			drag_end = event.position
			dragging = false
			drawing_paused = true
			if drag_start != drag_end:
				update()
				show_selector_button()

	if event is InputEventMouseMotion and dragging:
		# Draw the box while dragging.
		update()

# called from GravitySelector.gd given the argument for up,down,left,right
func make_area(direction: String):
	# Load area2d, calculate extents
	var area = base_anti_gravity.instance()
	var new_extents = (drag_end - drag_start) / 2

	# set all properties
	# note: the reason the shape isn't shared between all the areas is because "resource local to scene" is ticked in BaseAntiGravity. Just FYI
	area.get_node("CollisionShape2D").shape.extents = new_extents
	area.global_position = (drag_end + drag_start) / 2
	area.direction = direction


	# not connected anywhere but if we want to use it for stats or sometihng we have that
	Signals.emit_signal("area_created", area)
	add_child(area)

	# once it's made, then get rid of the drawing
	drawing_paused = false
	dragging = false
	update()
	# get rid of button
	selector_button.queue_free()


func show_selector_button():
	selector_button = preload("res://src/GravitySelect/GravitySelector.tscn").instance()

	selector_button.rect_global_position = (drag_end + drag_start) / 2
	add_child(selector_button)


func _draw():
	if dragging:
		selection_outline = Rect2(drag_start, get_global_mouse_position() - drag_start)
		# draw rectangle
		draw_rect(selection_outline, Color("#0d2d50"), true)
		# draw outline
		draw_rect(selection_outline, Color("#0078d9"), false)
	# keep the rectangle but don't update it
	elif drawing_paused:
		draw_rect(selection_outline, Color("#0d2d50"), true)
		draw_rect(selection_outline, Color("#0078d9"), false)

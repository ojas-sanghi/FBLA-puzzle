extends KinematicBody2D
class_name Actor

# Both the Player and Enemy inherit this scene as they have shared behaviours such as
# speed and are affected by gravity.
export var speed = Vector2(400.0, 700.0)
export var gravity = 1600

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

var in_antigravity := false
var antigravity_direction := ""

func _ready() -> void:
	Signals.connect("entered_antigravity", self, "_on_entered_antigravity")
	Signals.connect("exited_antigravity", self, "_on_exited_antigravity")

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	# apply custom rules if in antigravity
	# otherwise just add gravity
	if in_antigravity:
		if antigravity_direction == "up":
			_velocity.y += -980 * delta

		elif antigravity_direction == "down":
			_velocity.y += gravity * delta

		# antigravity for left and right for player are handled in movement code
		# calculate_move_velocity() in Player.gd
	else:
		_velocity.y += gravity * delta

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

extends Node2D

@export var min_value := 0
@export var max_value := 100
var value := 0

var dragging := false
var last_mouse_angle := 0.0

# Rotation limits in radians
var min_angle := deg_to_rad(-135)
var max_angle := deg_to_rad(135)

func _ready():

	$CircleSprite.rotation = min_angle
	value = min_value

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var circle_pos = $CircleSprite.global_position
		var circle_radius = $CircleSprite.texture.get_size().x * $CircleSprite.scale.x / 2

		if event.pressed and mouse_pos.distance_to(circle_pos) <= circle_radius:
			dragging = true
			# store initial mouse angle relative to center
			last_mouse_angle = (mouse_pos - global_position).angle()
		elif not event.pressed:
			dragging = false

	if dragging and event is InputEventMouseMotion:
		var mouse_dir = get_global_mouse_position() - global_position
		var current_mouse_angle = mouse_dir.angle()

		# Calculate angle delta relative to last frame
		var delta_angle = current_mouse_angle - last_mouse_angle

		# Handle wrapping around -PI/PI
		if delta_angle > PI:
			delta_angle -= 2 * PI
		elif delta_angle < -PI:
			delta_angle += 2 * PI

		# Apply delta only if it keeps rotation within limits
		var new_rotation = clamp($CircleSprite.rotation + delta_angle, min_angle, max_angle)
		$CircleSprite.rotation = new_rotation

		# Update normalized value
		var normalized = (new_rotation - min_angle) / (max_angle - min_angle)
		value = lerp(min_value, max_value, normalized)

		# Store current angle for next frame
		last_mouse_angle = current_mouse_angle

		print("Valve value:", value)
		$ProgressBar.value = value

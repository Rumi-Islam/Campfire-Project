extends Control

var dragging: bool = false
var current_wire: ColorRect = null
var start_pos: Vector2 = Vector2.ZERO
var connections_made: int = 0

@onready var wire_manager = $WireManager
@onready var left_container = $LeftTerminals
@onready var right_container = $RightTerminals

func _ready():
	# 1. Randomize the Right Side first
	shuffle_right_side()
	
	# 2. Setup Left Terminals
	for box in left_container.get_children():
		if box is ColorRect:
			box.mouse_filter = Control.MOUSE_FILTER_STOP
			box.gui_input.connect(_on_box_input.bind(box, true))
	
	# 3. Setup Right Terminals
	for box in right_container.get_children():
		if box is ColorRect:
			box.mouse_filter = Control.MOUSE_FILTER_STOP
			box.gui_input.connect(_on_box_input.bind(box, false))
	
	# 4. Ensure WireManager doesn't block clicks
	wire_manager.mouse_filter = Control.MOUSE_FILTER_IGNORE

func shuffle_right_side():
	# Get all children of the right container
	var children = right_container.get_children()
	
	# Remove them from the tree temporarily
	for child in children:
		right_container.remove_child(child)
	
	# Shuffle the list of nodes
	children.shuffle()
	
	# Add them back in the new random order
	for child in children:
		right_container.add_child(child)

func _process(_delta):
	if dragging and current_wire:
		var mouse_pos = get_local_mouse_position() - wire_manager.position
		update_wire_geometry(current_wire, start_pos, mouse_pos)

func _on_box_input(event: InputEvent, box: ColorRect, is_left_side: bool):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and is_left_side:
			dragging = true
			start_pos = box.global_position + (box.size / 2)
			
			current_wire = ColorRect.new()
			current_wire.color = box.color
			current_wire.size.y = 10
			current_wire.pivot_offset.y = 5
			current_wire.z_index = 100
			current_wire.top_level = true
			add_child(current_wire)
			
		elif not event.pressed and dragging:
			# --- NEW DETECTION LOGIC ---
			var mouse_pos = get_global_mouse_position()
			var target_box = get_box_at_pos(mouse_pos)
			
			if target_box and target_box.get_parent() == right_container and target_box.color == current_wire.color:
				# SUCCESS: Snap to the center of the target box
				var end_pos = target_box.global_position + (target_box.size / 2)
				update_wire_geometry(current_wire, start_pos, end_pos)
				
				current_wire = null # This locks it!
				connections_made += 1
				check_win_condition()
				print("Connected!")
			else:
				# FAIL: Delete
				current_wire.queue_free()
				current_wire = null
				print("Connection Failed")
				
			dragging = false

# Helper function to find which box is under the mouse
func get_box_at_pos(pos: Vector2):
	for box in right_container.get_children():
		if box is ColorRect:
			# Check if the global mouse position is inside the box's rectangle
			if box.get_global_rect().has_point(pos):
				return box
	return null

func update_wire_geometry(wire: ColorRect, start: Vector2, end: Vector2):
	var diff = end - start
	wire.global_position = start
	wire.size.x = max(diff.length(), 1.0)
	wire.rotation = diff.angle()

func check_win_condition():
	if connections_made == 4:
		print("Task Complete!")
		# You can trigger an animation or a sound here

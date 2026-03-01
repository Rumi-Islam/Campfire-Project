extends CharacterBody2D

@onready var _sprite = $AnimatedSprite2D 

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	pass

func _process(_delta):
	if Input.is_action_pressed("ui_right"):
		_sprite.play("walk")      # Matches the name in your SpriteFrames
		_sprite.flip_h = false    # Face right
	elif Input.is_action_pressed("ui_left"):
		_sprite.play("walk")
		_sprite.flip_h = true     # Face left
	else:
		_sprite.play("idle")      # Switches back to the idle loop




func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	$Label.text = (str)($".".global_position)
	move_and_slide()


func _on_player_died():
	die()


func die():
	$".".global_position = $"../Checkpoint".global_position


func _on_damage_body_entered(body: CharacterBody2D) -> void:
	if body == $".":
		die()



func _on_weak_spot_body_entered(body: CharacterBody2D) -> void:
	if body == $".":
		$"../Enemy".queue_free()

extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: float = 980.0

var direction: int = 1 # 1 = right, -1 = left

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# 1. Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Set Velocity based on direction
	velocity.x = direction * speed
	
	# 3. Move and Slide
	move_and_slide()

	# 4. Check for Wall Collision AFTER moving
	if is_on_wall():
		flip_direction()

func flip_direction():
	direction *= -1
	sprite.flip_h = (direction == -1)


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	print("show")
	$".".show()

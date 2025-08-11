extends CharacterBody2D

@export var movement_speed: float = 500.0
var character_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()

	# Flip sprite for horizontal movement
	if character_direction.x > 0:
		%AnimatedSprite2D.flip_h = false
	elif character_direction.x < 0:
		%AnimatedSprite2D.flip_h = true

	if character_direction != Vector2.ZERO:
		# Prevent faster diagonal movement
		velocity = character_direction.normalized() * movement_speed

		# Choose animation based on dominant axis
		if abs(character_direction.x) > abs(character_direction.y):
			if %AnimatedSprite2D.animation != "run_side":
				%AnimatedSprite2D.animation = "run_side"
		elif character_direction.y < 0:
			if %AnimatedSprite2D.animation != "run_up":
				%AnimatedSprite2D.animation = "run_up"
		else:
			if %AnimatedSprite2D.animation != "run_down":
				%AnimatedSprite2D.animation = "run_down"
	else:
		# Smoothly slow to a stop
		# velocity = velocity.move_toward(Vector2.ZERO, movement_speed * delta)
		velocity = Vector2.ZERO
		if %AnimatedSprite2D.animation != "idle":
			%AnimatedSprite2D.animation = "idle"

	# Godot 4: call with no arguments
	move_and_slide()

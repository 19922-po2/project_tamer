extends CharacterBody2D

@export var movement_speed: float = 500.0
var character_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")

	# Normalize to prevent diagonal speed boost
	if character_direction != Vector2.ZERO:
		character_direction = character_direction.normalized()

		# Set movement
		velocity = character_direction * movement_speed

		# Flip sprite for horizontal movement (if needed)
		if character_direction.x > 0:
			%AnimatedSprite2D_player.flip_h = false
		elif character_direction.x < 0:
			%AnimatedSprite2D_player.flip_h = true

		# Choose animation based on exact direction
		if character_direction.y < 0 and character_direction.x == 0:
			%AnimatedSprite2D_player.animation = "run_N"
		elif character_direction.y > 0 and character_direction.x == 0:
			%AnimatedSprite2D_player.animation = "run_S"
		elif character_direction.x > 0 and character_direction.y == 0:
			%AnimatedSprite2D_player.animation = "run_E"
		elif character_direction.x < 0 and character_direction.y == 0:
			%AnimatedSprite2D_player.animation = "run_E"
		elif character_direction.x > 0 and character_direction.y < 0:
			%AnimatedSprite2D_player.animation = "run_NE"
		elif character_direction.x < 0 and character_direction.y < 0:
			%AnimatedSprite2D_player.animation = "run_NE"
		elif character_direction.x > 0 and character_direction.y > 0:
			%AnimatedSprite2D_player.animation = "run_SE"
		elif character_direction.x < 0 and character_direction.y > 0:
			%AnimatedSprite2D_player.animation = "run_SE"

	else:
		velocity = Vector2.ZERO
		%AnimatedSprite2D_player.animation = "idle"

	move_and_slide()

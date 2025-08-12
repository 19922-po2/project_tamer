extends CharacterBody2D

@export var movement_speed: float = 500.0
var character_direction: Vector2 = Vector2.ZERO
#knowledge.lifeto.co/characters/4
#ezgif.com/gif-to-sprite
enum PlayerModes { Normal, Casting }
var player_mode = PlayerModes.Normal

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pet_attack") or Input.is_action_just_pressed("pet_follow"):
		player_mode = PlayerModes.Casting
		%AnimatedSprite2D_player.play("cast")
		await get_tree().create_timer(0.5).timeout
		%AnimatedSprite2D_player.play("idle")
		player_mode = PlayerModes.Normal

func _physics_process(_delta: float) -> void:
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	
	if player_mode == PlayerModes.Casting:
		return

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

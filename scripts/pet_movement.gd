extends CharacterBody2D

@export var follow_speed: float = 350.0
var player: CharacterBody2D
var min_distance_to_player: float = 150.0

func _ready():
	player = get_parent().get_node_or_null("Player")
	
func _physics_process(_delta: float) -> void:
	if player == null:
		return

	var to_player = player.global_position - global_position
	var distance_to_player = to_player.length()
	var player_velocity = Vector2.ZERO
	if "velocity" in player:
		player_velocity = player.velocity
		
	var desired_distance = distance_to_player - min_distance_to_player
	velocity = to_player.normalized() * min(desired_distance, follow_speed * _delta) / _delta
	if (player_velocity.length() > 0.0 and distance_to_player == min_distance_to_player) \
				or (player_velocity.length() == 0.0 and distance_to_player <= min_distance_to_player):
		velocity = Vector2.ZERO
	
	move_and_slide()

	# Animation & flip
	if velocity != Vector2.ZERO:
		var dir = velocity.normalized()
		if dir.x > 0:
			$AnimatedSprite2D_pet.flip_h = false
		elif dir.x < 0:
			$AnimatedSprite2D_pet.flip_h = true

		if dir.y < 0 and dir.x == 0:
			$AnimatedSprite2D_pet.animation = "run_N"
		elif dir.y > 0 and dir.x == 0:
			$AnimatedSprite2D_pet.animation = "run_S"
		elif dir.x > 0 and dir.y == 0:
			$AnimatedSprite2D_pet.animation = "run_E"
		elif dir.x < 0 and dir.y == 0:
			$AnimatedSprite2D_pet.animation = "run_E"
		elif dir.x > 0 and dir.y < 0:
			$AnimatedSprite2D_pet.animation = "run_NE"
		elif dir.x < 0 and dir.y < 0:
			$AnimatedSprite2D_pet.animation = "run_NE"
		elif dir.x > 0 and dir.y > 0:
			$AnimatedSprite2D_pet.animation = "run_SE"
		elif dir.x < 0 and dir.y > 0:
			$AnimatedSprite2D_pet.animation = "run_SE"
	else:
		$AnimatedSprite2D_pet.animation = "idle"

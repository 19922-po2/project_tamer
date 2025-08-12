extends CharacterBody2D

enum PetModes { Follow, Attack }

@export var follow_speed: float = 350.0
var player: CharacterBody2D
var min_distance_to_player: float = 150.0
var pet_mode = PetModes.Follow

func _ready():
	player = get_parent().get_node_or_null("Player")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pet_attack"):
		pet_mode = PetModes.Attack
	if Input.is_action_just_pressed("pet_follow"):
		pet_mode = PetModes.Follow
	
func _physics_process(_delta: float) -> void:
	if player == null:
		return

	if pet_mode == PetModes.Follow:  
		pet_follow_mode(_delta)
	if pet_mode == PetModes.Attack:  
		pet_attack_mode(_delta)

	# Animation & flip
	if velocity != Vector2.ZERO:
		var dir = velocity.normalized()
		var tol = 0.1  # tolerance for "almost zero" checks

		# Flip horizontally if moving left
		if dir.x > tol:
			$AnimatedSprite2D_pet.flip_h = false
		elif dir.x < -tol:
			$AnimatedSprite2D_pet.flip_h = true

		# North / South
		if dir.y < -tol and abs(dir.x) <= tol:
			$AnimatedSprite2D_pet.animation = "run_N"
		elif dir.y > tol and abs(dir.x) <= tol:
			$AnimatedSprite2D_pet.animation = "run_S"
		# East / West
		elif dir.x > tol and abs(dir.y) <= tol:
			$AnimatedSprite2D_pet.animation = "run_E"
		elif dir.x < -tol and abs(dir.y) <= tol:
			$AnimatedSprite2D_pet.animation = "run_E"  # flipped for west
		# Diagonals
		elif dir.x > tol and dir.y < -tol:
			$AnimatedSprite2D_pet.animation = "run_NE"
		elif dir.x < -tol and dir.y < -tol:
			$AnimatedSprite2D_pet.animation = "run_NE"  # flipped for NW
		elif dir.x > tol and dir.y > tol:
			$AnimatedSprite2D_pet.animation = "run_SE"
		elif dir.x < -tol and dir.y > tol:
			$AnimatedSprite2D_pet.animation = "run_SE"  # flipped for SW
	else:
		$AnimatedSprite2D_pet.animation = "idle"

func pet_follow_mode(_delta: float) -> void:
	#print("follow")
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
	
func pet_attack_mode(_delta: float) -> void:
	print("atack")
	pass

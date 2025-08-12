extends CharacterBody2D

var player_in_range: bool = false
var player_ref: Node2D = null
var pet_ref: Node2D = null
var speed: float = 100.0     # max movement speed
var friction: float = 500.0 # higher = faster stop

func _physics_process(delta: float) -> void:
	pet_ref = get_parent().get_node("Pet")
	if player_in_range and pet_ref: # Accelerate toward player
		var direction = (pet_ref.global_position - global_position).normalized()
		velocity = direction * speed
	else: # Smooth stop: move velocity toward zero
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move_and_slide()
	animate_and_flip()
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		player_in_range = true
		player_ref = body
		print("Player entered aggro range!")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player_ref:
		player_in_range = false
		player_ref = null
		pet_ref = null
		print("Player left aggro range!")
		
func animate_and_flip():
		# Animation & flip
	if velocity != Vector2.ZERO:
		var dir = velocity.normalized()
		var tol = 0.1  # tolerance for "almost zero" checks

		# Flip horizontally if moving left
		if dir.x > tol:
			$AnimatedSprite2D_bug_bear.flip_h = false
		elif dir.x < -tol:
			$AnimatedSprite2D_bug_bear.flip_h = true

		# North / South
		if dir.y < -tol and abs(dir.x) <= tol:
			$AnimatedSprite2D_bug_bear.animation = "run_N"
		elif dir.y > tol and abs(dir.x) <= tol:
			$AnimatedSprite2D_bug_bear.animation = "run_S"
		# East / West
		elif dir.x > tol and abs(dir.y) <= tol:
			$AnimatedSprite2D_bug_bear.animation = "run_E"
		elif dir.x < -tol and abs(dir.y) <= tol:
			$AnimatedSprite2D_bug_bear.animation = "run_E"  # flipped for west
		# Diagonals
		elif dir.x > tol and dir.y < -tol:
			$AnimatedSprite2D_bug_bear.animation = "run_NE"
		elif dir.x < -tol and dir.y < -tol:
			$AnimatedSprite2D_bug_bear.animation = "run_NE"  # flipped for NW
		elif dir.x > tol and dir.y > tol:
			$AnimatedSprite2D_bug_bear.animation = "run_SE"
		elif dir.x < -tol and dir.y > tol:
			$AnimatedSprite2D_bug_bear.animation = "run_SE"  # flipped for SW
	else:
		$AnimatedSprite2D_bug_bear.animation = "idle"

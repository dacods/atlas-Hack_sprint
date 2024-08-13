extends CharacterBody2D

# Enemy properties
var health = 30  # Adjust the health as needed
var speed = 100  # Enemy movement speed

# Patrol points
var patrol_point_a = Vector2(283, 972)
var patrol_point_b = Vector2(654, 985)
var current_target = patrol_point_b

# Distance at which the enemy starts chasing the player
var chase_distance = 50  # Adjust this value to set the chase range

# Reference to the player
var player = null

func _ready():
	# Find the player node (adjust the path if necessary)
	player = get_parent().get_node("CharacterBody2D")
	pass

func _process(delta):
	if player != null:
		# Calculate the distance to the player
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= chase_distance:
			# If the player is within chase distance, chase the player
			chase_player()
		else:
			# Otherwise, patrol between points
			patrol()

func patrol():
	# Move towards the current target
	var direction = (current_target - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	# Check if the enemy is close to the current target
	if global_position.distance_to(current_target) < 10:
		# Switch to the other patrol point
		if current_target == patrol_point_b:
			current_target = patrol_point_a
		else:
			current_target = patrol_point_b

func chase_player():
	# Move towards the player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func take_damage(amount):
	health -= amount
	print("Enemy took " + str(amount) + " damage, health now " + str(health))

	if health <= 0:
		die()

func die():
	print("Enemy died!")
	queue_free()  # Removes the enemy from the scene

# This function is called when a body enters the enemy's Area2D
func _on_area_2d_body_entered(body):
	if body.is_in_group("player_attack"):
		print("Player's attack detected!")
		take_damage(10)  # Adjust the damage value as needed

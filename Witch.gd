extends CharacterBody2D

signal witch_defeated  # Define the custom signal

# Enemy properties
var health = 30  # Adjust the health as needed
var speed = 100  # Enemy movement speed
var attack_cooldown = 1.0  # Cooldown between attacks in seconds
var can_attack = true  # Whether the witch can attack

# Patrol points
var patrol_point_a = Vector2(40, 191)
var patrol_point_b = Vector2(262, 465)
var current_target = patrol_point_b

# Distance at which the enemy starts chasing the player
var chase_distance = 350  # Adjust this value to set the chase range
var attack_distance = 20  # Distance within which the witch can attack the player

# Reference to the player
var player = null

func _ready():
	# Attempt to find the player in the scene tree
	player = get_tree().get_root().get_node("Node2D/CharacterBody2D")  # Adjust the path accordingly
	if player == null:
		print("Player not found!")

func _process(delta):
	if player != null:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= attack_distance:
			if can_attack:
				perform_attack()
		elif distance_to_player <= chase_distance:
			chase_player()
		else:
			patrol()

func patrol():
	var direction = (current_target - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	if global_position.distance_to(current_target) < 10:
		if current_target == patrol_point_b:
			current_target = patrol_point_a
		else:
			current_target = patrol_point_b

func chase_player():
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func perform_attack():
	can_attack = false

	if player != null:
		player.take_damage(10)  # Adjust the damage value as needed
		print("Witch attacked the player!")

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func take_damage(amount):
	health -= amount
	print("Witch took " + str(amount) + " damage, health now " + str(health))

	if health <= 0:
		die()

func die():
	print("Witch died!")
	emit_signal("witch_defeated")  # Emit the signal when the witch is defeated
	queue_free()  # Removes the witch from the scene

# This function is called when a body enters the witch's Area2D
func _on_area_2d_body_entered(body):
	if body.is_in_group("player_attack"):
		print("Player's attack detected!")
		take_damage(10)  # Adjust the damage value as needed

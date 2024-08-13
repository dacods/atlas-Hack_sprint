extends CharacterBody2D

var speed = 200

# Player health
var max_health = 100
var current_health = 100
var regeneration_rate = 5  # Amount of health to regenerate per interval
var regeneration_interval = 1.0  # Time in seconds between each regeneration
var time_since_last_damage = 0.0  # Time elapsed since the player last took damage
var regeneration_delay = 3.0  # Delay before regeneration starts after taking damage

# Attack-related variables
var is_attacking = false
var attack_cooldown = 0.5  # Half a second cooldown between attacks
var can_attack = true

# Reference to the player's inventory
var inventory = null

# Reference to the Label for displaying health
@onready var health_label = $"../CanvasLayer/HealthLabel" # Adjusted the path to match your scene

# Reference to the Marker2D for respawn point
@onready var respawn_point = $"../Marker2D"  # Adjust the path to match your scene

func _ready():
	# Debugging to check if HealthLabel is found
	if health_label == null:
		print("HealthLabel not found!")
	else:
		print("HealthLabel found successfully!")
		# Initialize the health label
		update_health_label()

	# Use the correct path to find the inventory node
	inventory = get_node("../CharacterBody2D/Inventory")

	if inventory == null:
		print("Inventory not found!")
	else:
		print("Inventory found successfully!")

func _process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	velocity = direction.normalized() * speed
	move_and_slide()

	# Handle attack input
	if Input.is_action_just_pressed("ui_attack") and can_attack:
		if has_axe():
			print("Axe is in inventory, performing attack...")
			perform_attack()
		else:
			print("Player tried to attack, but does not have an axe!")

	# Update time since last damage
	time_since_last_damage += delta

	# Regenerate health if the player hasn't taken damage for a while
	if time_since_last_damage >= regeneration_delay:
		regenerate_health(delta)

func perform_attack():
	is_attacking = true
	can_attack = false

	# Print statement to indicate attack has started
	print("Player is attacking!")

	# After attacking, start the cooldown
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	is_attacking = false

	# Print statement to indicate the attack cooldown has finished
	print("Attack cooldown finished, can attack again.")

	# Check for collisions with enemies or objects
	check_attack_collision()

func check_attack_collision():
	var attack_area = $AttackArea2D  # Replace with the correct path to your AttackArea2D node
	if attack_area:
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("enemies"):
				body.take_damage(10)  # Apply damage to the enemy
				print("Enemy hit!")

func take_damage(amount):
	current_health -= amount
	print("Player took " + str(amount) + " damage, current health: " + str(current_health))

	# Reset the time since last damage to 0
	time_since_last_damage = 0.0

	# Update the health label
	if health_label != null:
		update_health_label()

	if current_health <= 0:
		die()

func die():
	print("Player died!")
	respawn()

func respawn():
	# Reset the player's health
	current_health = max_health

	# Update the health label
	update_health_label()

	# Move the player to the respawn point's position
	global_position = respawn_point.global_position

	# Print a message indicating the player has respawned
	print("Player has respawned at position: " + str(respawn_point.global_position))

func regenerate_health(delta):
	if current_health < max_health:
		current_health += regeneration_rate * delta
		current_health = clamp(current_health, 0, max_health)
		update_health_label()

func update_health_label():
	if health_label != null:
		# Round the health value before displaying it
		health_label.text = "Health: " + str(int(round(current_health))) + "/" + str(max_health)

func has_axe() -> bool:
	if inventory != null:
		for item in inventory.items:
			if item.name == "Axe":
				return true
	return false

func _on_area_2d_body_entered(body):
	pass  # Replace with function body.


func _on_house_candy_area_body_entered(body):
	pass # Replace with function body.

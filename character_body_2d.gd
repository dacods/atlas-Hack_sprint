extends CharacterBody2D

var speed = 200

# Player health
var max_health = 100
var current_health = 100

# Attack-related variables
var is_attacking = false
var attack_cooldown = 0.5  # Half a second cooldown between attacks
var can_attack = true

# Reference to the player's inventory
var inventory = null

# Reference to the ProgressBar for displaying health
@onready var health_bar = $"../CanvasLayer/HealthBar"  # Adjust the path to match your scene

func _ready():
	# Debugging to check if HealthBar is found
	if health_bar == null:
		print("HealthBar not found!")
	else:
		print("HealthBar found successfully!")
		# Initialize the health bar
		health_bar.max_value = max_health
		health_bar.value = current_health

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

	# Update the health bar
	if health_bar != null:
		health_bar.value = current_health

	if current_health <= 0:
		die()

func die():
	print("Player died!")
	queue_free()  # Or handle game over logic here

func has_axe() -> bool:
	if inventory != null:
		for item in inventory.items:
			if item.name == "Axe":
				return true
	return false

func _on_area_2d_body_entered(body):
	pass  # Replace with function body.

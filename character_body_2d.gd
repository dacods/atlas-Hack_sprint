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
var inventory: Node = null

# Reference to the Label for displaying health
@onready var health_label: Label = $"../CanvasLayer/HealthLabel" # Adjusted the path to match your scene

# Reference to the Marker2D for respawn point
@onready var respawn_point: Marker2D = $"../Marker2D"  # Adjust the path to match your scene
@onready var event_respawn_point: Marker2D = $"../EventMarker"  # Adjust the path to match your scene

# References for the text sequence and fade
@onready var text_panel: Panel = $"../CanvasLayer/TextPanel"  # Adjust the path to your Panel node
@onready var fade_rect: ColorRect = $"../CanvasLayer/FadeRect"  # Adjust the path to your ColorRect node
@onready var house_candy_area: Area2D = $"../HouseCandyArea"  # Adjust the path to your Area2D node

# Reference to the Enemy Objective Canvas and Label
@onready var objective_panel: Panel = $"../EnemyObjectiveCanvas/ObjectivePanel"  # Adjust the path to your Panel node
@onready var objective_label: Label = $"../EnemyObjectiveCanvas/ObjectivePanel/ObjectiveLabel"  # Adjust the path to your Label node

# Sequence control variables
var text_sequence_active = false
var event_triggered = false  # New variable to ensure the event triggers only once

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

	# Hide the panel and fade rect initially
	text_panel.visible = false
	fade_rect.visible = false
	fade_rect.color = Color(0, 0, 0, 0)  # Transparent initially

	# Hide the objective panel initially
	objective_panel.visible = false

	# Connect the area entered signal to start the sequence
	house_candy_area.body_entered.connect(_on_house_candy_area_body_entered)

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

func _on_house_candy_area_body_entered(body: Node):
	if body == self and not text_sequence_active and not event_triggered:
		text_sequence_active = true
		event_triggered = true  # Set the flag to prevent reactivation
		start_text_sequence()

func start_text_sequence() -> void:
	text_panel.visible = true  # Show the panel with the text
	show_text("You hear an unfamiliar voice talking to Gretel.")
	
	await get_tree().create_timer(2.5).timeout  # Show first text for 2.5 seconds

	show_text("*WHACK*")

	await get_tree().create_timer(1.5).timeout  # Show second text for 1.5 seconds

	fade_to_black()

	await get_tree().create_timer(1.5).timeout  # Wait for the fade to complete

	respawn_player()

	# Show the "Defeat all enemies" message after respawning
	show_objective("Defeat all enemies in the area! Then head back to the witch and defeat her!")

func show_text(message: String) -> void:
	text_panel.get_child(0).text = message  # Assuming the Label is the first child

func show_objective(message: String) -> void:
	objective_label.text = message
	objective_panel.visible = true
	
	# Hide the objective message after a few seconds
	await get_tree().create_timer(3.0).timeout  # Adjust the duration as needed
	objective_panel.visible = false

func fade_to_black() -> void:
	fade_rect.visible = true
	var fade_duration = 1.5  # 1.5 seconds fade duration
	var fade_animation = get_tree().create_timer(fade_duration).timeout
	var fade_step = 1.0 / fade_duration

	for i in range(int(fade_duration / get_process_delta_time())):
		fade_rect.color.a += fade_step * get_process_delta_time()
		await get_tree().create_timer(get_process_delta_time()).timeout

func respawn_player() -> void:
	print("Respawning player...")

	# Reset the player's health
	current_health = max_health
	print("Health reset to max: " + str(max_health))

	# Update the health label
	if health_label != null:
		update_health_label()
	else:
		print("Health label is null!")

	# Move the player to the event respawn point's position
	if event_respawn_point != null:
		global_position = event_respawn_point.global_position
		print("Player has respawned at position: " + str(event_respawn_point.global_position))
	else:
		print("Event respawn point not found!")

	# Reset other states if needed
	text_panel.visible = false
	fade_rect.visible = false
	fade_rect.color = Color(0, 0, 0, 0)
	text_sequence_active = false

func perform_attack() -> void:
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

func check_attack_collision() -> void:
	var attack_area = $AttackArea2D  # Replace with the correct path to your AttackArea2D node
	if attack_area:
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("enemies"):
				body.take_damage(10)  # Apply damage to the enemy
				print("Enemy hit!")

func take_damage(amount: int) -> void:
	current_health -= amount
	print("Player took " + str(amount) + " damage, current health: " + str(current_health))

	# Reset the time since last damage to 0
	time_since_last_damage = 0.0

	# Update the health label
	if health_label != null:
		update_health_label()

	if current_health <= 0:
		die()

func die() -> void:
	print("Player died!")
	respawn_player()  # Call the respawn_player function instead of respawn()

func regenerate_health(delta: float) -> void:
	if current_health < max_health:
		current_health += regeneration_rate * delta
		current_health = clamp(current_health, 0, max_health)
		update_health_label()

func update_health_label() -> void:
	if health_label != null:
		# Round the health value before displaying it
		health_label.text = "Health: " + str(int(round(current_health))) + "/" + str(max_health)
	else:
		print("Health label is null!")

func has_axe() -> bool:
	if inventory != null:
		for item in inventory.items:
			if item.name == "Axe":
				return true
	return false

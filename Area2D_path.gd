extends Area2D

# References for the UI elements
@onready var no_weapon_panel = $"../NoWeaponCanvas/Panel"
@onready var no_weapon_label = $"../NoWeaponCanvas/Panel/Label"
@onready var has_weapon_panel = $"../HasWeaponCanvas/Panel"
@onready var has_weapon_label = $"../HasWeaponCanvas/Panel/Label"

# Reference to the player and inventory
@onready var player = get_parent().get_node("CharacterBody2D")
@onready var inventory = player.get_node("Inventory")

# Flags to track if the message has been shown
var has_weapon_message_shown = false
var is_restricted = false  # Tracks if the player is currently in a restricted area

func _ready():
	# Ensure both panels are hidden initially
	print("Script is ready, hiding panels initially.")
	no_weapon_panel.visible = false
	has_weapon_panel.visible = false
	
	# Connect the signal programmatically
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _on_Area2D_body_entered(body):
	print("body_entered signal triggered by: ", body)
	if body == player:
		print("Player has entered the area.")
		if not has_axe():
			print("Player does not have the axe.")
			# Show the "I don't feel safe" message
			no_weapon_panel.visible = true
			no_weapon_label.text = "Hansel: I don't feel safe going this way without a weapon."
			
			# Move the player slightly to the right and prevent further movement
			is_restricted = true
			player.global_position.x += 10  # Adjust the value as needed
			player.speed = 0  # Halt the player's movement
			
			# Hide the message after a delay
			await get_tree().create_timer(3.0).timeout
			print("Hiding no weapon panel.")
			no_weapon_panel.visible = false

			# Recheck the player's position to stop them from advancing
			check_player_position()

		elif has_axe() and not has_weapon_message_shown:
			print("Player has the axe.")
			# Show the "Hopefully this axe will keep me safe" message
			has_weapon_panel.visible = true
			has_weapon_label.text = "Hopefully this axe will keep me safe."

			# Allow the player to move down the path after the message is shown
			await get_tree().create_timer(3.0).timeout
			print("Hiding has weapon panel.")
			has_weapon_panel.visible = false

			# Mark the message as shown
			has_weapon_message_shown = true
	else:
		print("Entered body is not the player.")

func check_player_position():
	# Continuously check the player's position
	while is_restricted and not has_axe() and is_player_in_area():
		await get_tree().create_timer(0.5).timeout  # Recheck every 0.5 seconds
		player.global_position.x += 10  # Keep moving the player slightly to the right

	# Allow the player to move again if they leave the area or get the axe
	if not is_player_in_area() or has_axe():
		is_restricted = false
		player.speed = 200

func is_player_in_area() -> bool:
	# Get the bounding box (rectangular) of the CollisionShape2D
	var collision_shape = $CollisionShape2D.shape
	if collision_shape is RectangleShape2D:
		var area_size = collision_shape.extents
		var area_center = global_position
		var player_pos = player.global_position

		# Check if the player is within the bounds of the area
		return abs(player_pos.x - area_center.x) <= area_size.x and abs(player_pos.y - area_center.y) <= area_size.y

	# If not a rectangle, just return false as a fallback
	return false

func has_axe() -> bool:
	print("Checking if player has axe.")
	for item in inventory.items:
		print("Checking inventory item: ", item.name)
		if item.name == "Axe":
			print("Axe found in inventory.")
			return true
	print("Axe not found in inventory.")
	return false

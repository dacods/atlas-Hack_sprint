extends Node2D

# Reference to the sword sprite (optional, only if you still want it to appear)
@onready var sword = $Sword

# Reference to the player's inventory
var inventory = null

# Reference to the message label
var message_label = null

# Chest opened state
var is_open = false

func _ready():
	# Ensure the sword is hidden initially
	if sword != null:
		sword.visible = false

	# Use the correct path to find the inventory node
	inventory = get_node("../CharacterBody2D/Inventory")
	
	# Get the message label (adjust the path if needed)
	message_label = get_node("../CharacterBody2D/MessageLabel")

	if inventory == null:
		print("Inventory still not found!")
	else:
		print("Inventory found successfully!")

	if message_label == null:
		print("MessageLabel not found!")
	else:
		print("MessageLabel found successfully!")

	$Area2D.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _on_Area2D_body_entered(body):
	if body is CharacterBody2D and not is_open:
		print("Player is near the chest")
		show_message("You have found an Axe!")  # Show message when the player reaches the chest
		open_chest()

func show_message(message):
	if message_label != null:
		message_label.text = message
		message_label.modulate = Color(0, 0, 0)  # Set text color to black
		message_label.visible = true
		
		# Hide the message after 2 seconds using await
		await get_tree().create_timer(2.0).timeout
		message_label.visible = false

func open_chest():
	is_open = true
	if inventory != null:
		print("Adding Axe to inventory")  # Debugging output
		inventory.add_item({"name": "Axe", "type": "Weapon"})
		print("Axe has been added to the inventory")
	else:
		print("Inventory not found!")

func _on_Area2D_body_exited(body):
	if body is CharacterBody2D:
		print("Player left the chest area")
		pass

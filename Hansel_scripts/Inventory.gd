extends Node

var items = []

# Reference to the HBoxContainer and its children (TextureRect and Label)
var inventory_box = null
var item_icon = null
var item_name = null

func _ready():
	# Adjust the path to find the HBoxContainer node and its children
	inventory_box = get_node("/root/Node2D/CanvasLayer/HBoxContainer")
	item_icon = inventory_box.get_node("TextureRect")
	item_name = inventory_box.get_node("Label")  # We will hide or remove this later

	if inventory_box == null or item_icon == null or item_name == null:
		print("Inventory UI components not found!")
	else:
		print("Inventory UI components found successfully!")

	# Clear any existing inventory display
	clear_inventory_display()

func add_item(item):
	items.append(item)
	print(item.name + " has been added to the inventory")

	# Update the display after adding the new item
	update_inventory_display(item)

func update_inventory_display(item):
	# Hide the label if you don't want to show the text
	item_name.visible = false
	
	# Update the icon with the item's texture (replace with the actual texture path)
	item_icon.texture = load("res://Hansel_assets/Images/axe.png")  # Replace with the correct path
	
	# Set the texture rectangle to be visible
	item_icon.visible = true

func clear_inventory_display():
	# Hide the display initially
	if item_icon != null:
		item_icon.visible = false
	if item_name != null:
		item_name.visible = false

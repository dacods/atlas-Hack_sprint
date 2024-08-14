extends CharacterBody2D


func _ready():
	self.name = "Player"  # set the name of the player node

@export var speed: int = 500 # is 100, 500 for testing

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed
	
func _physics_process(_delta):
	handleInput()
	move_and_slide()

var inventory = {}
var last_inventory = {}

# update last_inventory to the current state
func _process(_delta):
	if inventory != last_inventory:
		print(inventory)
		last_inventory = inventory.duplicate()

func obtain_key():
	add_to_inventory("key", 1)
	print("Player: I got the key!")

func add_to_inventory(item_name: String, quantity: int):
	if inventory.has(item_name):
		inventory[item_name] += quantity
	else:
		inventory[item_name] = quantity

func has_item(item_name: String) -> bool:
	return inventory.has(item_name) and inventory[item_name] > 0

func _on_body_entered(body):
	if body.is_in_group("npc"):
		body.show_chat_bubble()

func _on_body_exited(body):
	if body.is_in_group("npc"):
		body.hide_chat_bubble()

extends Node2D

# References to the Witch trigger and the enemy scene to spawn
@onready var witch_trigger: Area2D = $"../HouseCandyArea"  # Adjust the path to your witch trigger area
@onready var enemy_spawner: Node2D = $"../EnemySpawner"  # Adjust the path to the EnemySpawner node

# Preload the enemy scene
var enemy_scene = preload("res://enemy.tscn")  # Adjust the path to your enemy scene

var enemies_spawned = false

func _ready():
	# Connect the signal for when the player enters the Witch trigger
	witch_trigger.connect("body_entered", Callable(self, "_on_witch_trigger_body_entered"))

func _on_witch_trigger_body_entered(body: Node):
	if body.is_in_group("player") and not enemies_spawned:
		enemies_spawned = true  # Ensure this only happens once
		spawn_enemies()

func spawn_enemies():
	print("Spawning enemies dynamically!")
	
	# Define multiple spawn areas as a list of Rect2
	var spawn_areas = [
		Rect2(Vector2(100, 100), Vector2(200, 200)),  # Area 1
		Rect2(Vector2(300, 300), Vector2(200, 200)),  # Area 2
		Rect2(Vector2(500, 500), Vector2(200, 200))   # Area 3
	]
	
	for i in range(5):  # Adjust the number of enemies you want to spawn
		var enemy_instance = enemy_scene.instantiate()  # Use instantiate() in Godot 4
		
		# Randomly select a spawn area
		var chosen_area = spawn_areas[randi() % spawn_areas.size()]
		
		# Randomize position within the chosen area
		var random_position = chosen_area.position + Vector2(
			randf_range(0, chosen_area.size.x),
			randf_range(0, chosen_area.size.y)
		)
		
		enemy_instance.position = random_position
		enemy_spawner.add_child(enemy_instance)
		
		# Ensure the enemy's _ready function runs and it initializes correctly
		if enemy_instance.has_method("_ready"):
			enemy_instance._ready()

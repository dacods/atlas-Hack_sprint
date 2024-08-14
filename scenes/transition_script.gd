extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		print("Player entered the area. Transitioning to the next scene.")
		get_tree().change_scene_to_file("res://Hansel_scenes/node_2d.tscn")

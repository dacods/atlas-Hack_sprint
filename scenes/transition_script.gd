extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		print("Player entered the area. Transitioning to the next scene with fade.")
		$CanvasLayer.fade_to_scene("res://Hansel_scenes/node_2d.tscn", 1.5)


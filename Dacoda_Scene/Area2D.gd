extends Area2D

func _ready():
	# Optional: Initialize anything here if needed
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("player_attack"):
		# Assuming the player's attack area is in the "player_attack" group
		var player = body.get_parent()
		if player.has_method("perform_attack"):
			take_damage(10)  # Replace 10 with the appropriate damage value

func take_damage(amount):
	var enemy = get_parent()
	if enemy.has_method("take_damage"):
		enemy.take_damage(amount)


func _on_body_entered(body):
	pass # Replace with function body.

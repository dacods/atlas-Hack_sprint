extends CharacterBody2D

const lines_with_key: Array[String] = [
	"Pascal has a note:\ntake the key to the chest!\nYou found a key"
]

const lines_lizard_noise: Array[String] = [
	"Blah!:P"
]

var has_given_key: bool = false
var has_shown_noise: bool = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		if not has_given_key:
			give_key_to_player(body)
			has_given_key = true
			show_dialogue(lines_with_key)
		elif has_given_key:
			if not has_shown_noise:
				show_dialogue(lines_lizard_noise)
				has_shown_noise = true

func give_key_to_player(player):
	player.obtain_key()
	print("NPC: I've got a key for you!")

func show_dialogue(lines: Array[String]):
	if DialogueManager:
		DialogueManager.start_dialogue(global_position, lines)

func _on_body_exited(body):
	if body.name == "Player":
		if DialogueManager.is_dialogue_active:
			DialogueManager.hide_text_box()
			if has_given_key:
				has_shown_noise = false

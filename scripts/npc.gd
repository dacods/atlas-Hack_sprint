extends CharacterBody2D

const lines: Array[String] = [
	"Rapunzel, Rapunzel," +
	"Let down your hair!"
]

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		show_dialogue()

func show_dialogue():
	if DialogueManager:
		DialogueManager.start_dialogue(global_position, lines)

func _on_body_exited(body):
	if body.name == "Player":
		if DialogueManager.is_dialogue_active:
			DialogueManager.hide_text_box()

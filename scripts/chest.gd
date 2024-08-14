extends StaticBody2D

@export var required_item: String = "key"
@export var story_text: Array[String] = [
	"Once upon a time, there was a girl named Rapunzel,",
	"who was taken by an enchantress and locked in a tall tower with no door or stairs.",
	"Her long, golden hair was her only connection to the outside world.",
	"Every day, the enchantress would call out, 'Rapunzel, Rapunzel, let down your hair,'",
	"and Rapunzel would lower her hair for the enchantress to climb up.",
	"One day, a prince heard Rapunzel singing from her tower and fell in love with her voice.",
	"He waited for the enchantress to leave, then called out the same words.",
	"Rapunzel, thinking it was the enchantress, let down her hair, and the prince climbed up.",
	"Rapunzel and the prince met and fell in love. They planned to escape together,",
	"but the enchantress discovered their plan.",
	"In a fit of rage, she cut off Rapunzel's hair and banished her to a faraway desert.",
	"The enchantress tricked the prince into climbing the tower, only to throw him down, blinding him with her curse.",
	"Blinded and heartbroken, the prince wandered the land until he found Rapunzel in the desert.",
	"Her tears of joy healed his blindness, and they returned to his kingdom, where they lived happily ever after."
]

var is_unlocked = false
var current_line_index: int = 0
var is_dialogue_active: bool = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func show_message(message: String):
	if DialogueManager:
		DialogueManager.start_dialogue(global_position, [message])

func _on_body_entered(body):
	if body.name == "Player":
		if body.has_item(required_item):
			if not is_unlocked:
				unlock_chest()
				show_story()
			else:
				if not is_dialogue_active:
					# restart story if chest was previously unlocked
					show_story()
		else:
			if DialogueManager.is_dialogue_active:
				DialogueManager.hide_text_box()
			show_message("It seems to be locked.")

func unlock_chest():
	is_unlocked = true
	print("Chest: You've unlocked the chest!")

func show_story():
	current_line_index = 0
	is_dialogue_active = true
	_display_line()

func _display_line():
	if current_line_index < story_text.size():
		var line = story_text[current_line_index]
		if DialogueManager:
			DialogueManager.start_dialogue(global_position, [line])
	else:
		DialogueManager.start_dialogue(global_position, ["You've read the entire story."])
		print("Chest: Story is complete.")
		is_dialogue_active = false

func _unhandled_input(event):
	if event.is_action_pressed("advance_dialogue"):
		if is_dialogue_active and DialogueManager.is_dialogue_active:
			DialogueManager.hide_text_box()
			
			current_line_index += 1
			if current_line_index < story_text.size():
				_display_line()
			else:
				DialogueManager.start_dialogue(global_position, ["You've read the entire story."])
				is_dialogue_active = false

func _on_body_exited(body):
	if body.name == "Player":
		if DialogueManager.is_dialogue_active:
			DialogueManager.hide_text_box()
		is_dialogue_active = false

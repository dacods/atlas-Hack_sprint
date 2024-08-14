extends Node2D

# References to UI elements for the final messages and fade effect
@onready var final_message_panel: Panel = $CanvasLayer/FinalMessagePanel  # Adjust the path to your Panel node
@onready var final_message_label: Label = $CanvasLayer/FinalMessagePanel/FinalMessageLabel  # Adjust the path to your Label node
@onready var fade_rect: ColorRect = $CanvasLayer/FadeRect  # Adjust the path to your FadeRect node

# Reference to the trigger for the final fight
@onready var final_fight_trigger: Area2D = $FinalFightTrigger  # Adjust the path to your final fight trigger

# Reference to the Witch node in the scene
@onready var witch_node: CharacterBody2D = $"../Witch"  # Adjusted to your scene structure

func _ready():
	# Set the initial state for the final message panel and fade rect
	final_message_panel.visible = false
	fade_rect.visible = false
	fade_rect.color = Color(0, 0, 0, 0)  # Start with a fully transparent black color

	# Connect the trigger signal for starting the final fight
	final_fight_trigger.connect("body_entered", Callable(self, "_on_final_fight_trigger_body_entered"))

	# Connect the witch's defeat signal
	if witch_node.has_signal("witch_defeated"):
		witch_node.connect("witch_defeated", Callable(self, "_on_witch_defeated"))

func _on_final_fight_trigger_body_entered(body: Node):
	if body.is_in_group("player"):
		start_final_fight()

func start_final_fight():
	print("Final fight started! Defeat the witch!")

func _on_witch_defeated():
	print("Witch defeated!")
	start_final_sequence()

func start_final_sequence():
	print("Starting final sequence...")
	fade_to_black()

	await get_tree().create_timer(1.5).timeout  # Wait for the fade to complete

	show_final_message()

func fade_to_black() -> void:
	fade_rect.visible = true
	var fade_duration = 1.5  # 1.5 seconds fade duration
	var fade_step = 1.0 / fade_duration

	while fade_rect.color.a < 1.0:
		fade_rect.color.a += fade_step * get_process_delta_time()
		await get_tree().create_timer(get_process_delta_time()).timeout

	# Ensure the color is fully opaque black after fading
	fade_rect.color.a = 1.0

func show_final_message() -> void:
	final_message_panel.visible = true
	final_message_label.text = "Congratulations! You helped Hansel free Gretel from the witch and they made it home safe."

	await get_tree().create_timer(3.0).timeout  # Show the first message for 3 seconds

	final_message_label.text = "Thanks for playing!"  # Change the message

	await get_tree().create_timer(3.0).timeout  # Show the second message for 3 seconds

	fade_rect.color = Color(0, 0, 0, 1)  # Keep the screen black after the final message

extends Node2D  # or Control, depending on your scene

# References for UI elements
@onready var text_panel: Panel = $CanvasLayer2/TextPanel  # Adjust the path to your Panel node
@onready var text_label: Label = $CanvasLayer2/TextPanel/Label  # Adjust the path to your Label node
@onready var fade_rect: ColorRect = $CanvasLayer2/FadeRect  # Adjust the path to your ColorRect node

func _ready():
	# Set the initial state
	text_panel.visible = true
	fade_rect.visible = true
	fade_rect.color = Color(0, 0, 0, 1)  # Fully black
	
	# Start the sequence
	start_intro_sequence()

func start_intro_sequence() -> void:
	# Show the first text
	show_text("Hansel: ZZZZZ")
	
	# Wait for 2 seconds
	await get_tree().create_timer(2.0).timeout
	
	# Show the second text
	show_text("*Loud Crash*")
	
	# Wait for 1.5 seconds
	await get_tree().create_timer(1.5).timeout
	
	# Show the third text
	show_text("Hansel: What was that?")
	
	# Wait for 2 seconds
	await get_tree().create_timer(2.0).timeout
	
	# Fade in from black
	fade_in_from_black()

func show_text(message: String) -> void:
	text_label.text = message

func fade_in_from_black() -> void:
	var fade_duration = 1.5  # 1.5 seconds fade duration
	var fade_step = 1.0 / fade_duration

	for i in range(int(fade_duration / get_process_delta_time())):
		var delta_time = get_process_delta_time()
		fade_rect.color.a -= fade_step * delta_time
		text_panel.modulate.a -= fade_step * delta_time
		await get_tree().create_timer(delta_time).timeout
	
	fade_rect.visible = false  # Hide the rect after fade in
	text_panel.visible = false  # Hide the text panel after fade in

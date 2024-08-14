extends Area2D

var text_displayed = false

# Adjust the paths to your new CanvasLayer, Panel, and Label
@onready var text_panel: Panel = $"../CanvasLayer3/Panel"
@onready var text_label: Label = $"../CanvasLayer3/Panel/Label"

func _ready():
	connect("body_entered", Callable(self, "_on_StartAreaTrigger_body_entered"))
	
	# Ensure the text panel is hidden initially
	text_panel.visible = false
	print("Text panel is hidden initially")

func _on_StartAreaTrigger_body_entered(body):
	print("body_entered signal triggered")
	print("Body: " + str(body))
	
	if body.is_in_group("player"):
		print("Body is in player group")
		if not text_displayed:
			print("Text not yet displayed, showing text now")
			show_text("Hansel: Something feels off, I can't find Gretel anywhere.")
			text_displayed = true  # Ensures the message only shows once
		else:
			print("Text has already been displayed, not showing again")
	else:
		print("Body is not in player group")

func show_text(message: String) -> void:
	if text_panel:
		print("Showing text: " + message)
		text_panel.visible = true
		text_label.text = message
		
		# Hide the text after a delay if needed
		await get_tree().create_timer(3.0).timeout  # Adjust the time as needed
		text_panel.visible = false
		print("Text panel hidden after delay")

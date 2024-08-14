extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var loading_label = $LoadingLabel  # Reference to the loading label
var timer: Timer = Timer.new()

func _ready():
	add_child(timer)
	timer.one_shot = true
	loading_label.visible = false  

func fade_out(duration: float) -> void:
	color_rect.color.a = 0
	color_rect.visible = true
	loading_label.visible = true  
	var steps = duration * 60  
	for i in range(steps):
		color_rect.color.a += 1.0 / steps
		timer.start(1 / 60.0)
		await timer.timeout  

func fade_in(duration: float) -> void:
	color_rect.color.a = 1
	var steps = duration * 60  
	for i in range(steps):
		color_rect.color.a -= 1.0 / steps
		timer.start(1 / 60.0)
		await timer.timeout  
	color_rect.visible = false
	loading_label.visible = false

func fade_to_scene(scene_path: String, duration: float = 1.0, extra_load_time: float = 1.0) -> void:
	await fade_out(duration)
	await timer_timeout(extra_load_time)  # Additional loading time
	get_tree().change_scene_to_file(scene_path)
	await fade_in(duration)

func timer_timeout(wait_time: float) -> void:
	timer.start(wait_time)
	await timer.timeout

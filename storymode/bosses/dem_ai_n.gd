extends Node2D

@onready var player: Player = $player
@onready var intro: AnimationPlayer = $intro
@onready var demainspeech: Label = $speech
@onready var sfx: AudioStreamPlayer = $sfx
var talking: bool

@onready var bulletspawns: Node2D = $bulletspawns

var bullet = preload("res://bullettypes/bullet.tscn")
var helper = preload("res://bullettypes/helper.tscn")
var speeder = preload("res://bullettypes/speeder.tscn")
var looker = preload("res://bullettypes/looker.tscn")


var bulletamount = 1
var healchance = 100
var speedychance = 5
var lookerexists = false
var lookerNode

var started = false

var milestones = 50
var current_phase = 0

var windowmoving = false


func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	var window = get_window()
	window.size = Vector2i(1152, 648)
	window.unresizable = true
	
	var screen_size = DisplayServer.screen_get_size(0)
	window.position = (screen_size - window.size) / 2
	Sounds.uncalm_music()
	
	window.grab_focus()


func _process(delta: float) -> void:
	if player.parries == milestones:
		current_phase += 1
		phases(current_phase)


func phases(phase: int):
	Sounds.music.seek(0)
	milestones *= 2
	started = false
	for child in get_children():
		if child.is_in_group("b"):
			child.queue_free()
	player.SPEED = 0
	player.start = false
	if intro.get_animation("phase "+str(phase)):
		intro.play("phase "+str(phase))
	else:
		win()


func talk(text: String):
	demainspeech.text = text
	show_next_letter()


func sudden_music_shift(sound_position: float):
	Sounds.music.seek(sound_position)
	player.SPEED = Characters.chosen_character["speed"]
	player.start = true
	started = true

func _exit_tree() -> void:
	var window = get_window()
	window.unresizable = false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func show_next_letter(speed := 0.06):
	var full_text = demainspeech.text
	demainspeech.text = full_text

	demainspeech.visible_ratio = 0.0  # Start with no visible characters

	var total_chars = demainspeech.get_total_character_count()
	var reveal_step = 1.0 / total_chars

	for i in range(total_chars):
		demainspeech.visible_ratio = (i + 1) * reveal_step
		sfx.stop()
		sfx.play()
		await get_tree().create_timer(speed).timeout


func _on_timer_timeout() -> void:
	if started:
		lookerexists = false
		for i in bulletamount:
			var b
			
			var GAMBLING = randi_range(1, healchance)
			if GAMBLING == 1:
				b = helper.instantiate()
			else:
				if randi_range(1, speedychance) == 1:
					b = speeder.instantiate()
				else:
					
					lookerNode = get_node_or_null("looker")
					lookerexists = lookerNode != null
					
					if randi_range(1, 100) == 1 and not lookerexists:
						b = looker.instantiate()
					else:
						b = bullet.instantiate()
			
			spawn_bullet(b)

func spawn_bullet(b):
		
	add_child(b)
	var bulletspawn = bulletspawns.get_child(randi_range(0, bulletspawns.get_child_count() - 1))
		
	match b.name:
		"speeder":
			b.SPEED = randf_range(400, 600)
		"bullet":
			b.SPEED = randf_range(150, 250)
		"helper":
			b.SPEED = randf_range(150, 250)
		"upgrader":
			b.SPEED = randf_range(30, 80)
		"looker":
			b.SPEED = 60
			b.name = "looker"
	b.position = bulletspawn.position


func change_movewindow_variable(boolean: bool):
	windowmoving = boolean
	print(windowmoving)


func move_window():
	if windowmoving:
		var window := get_window()
		var screen_size := DisplayServer.screen_get_size()
		
		var max_x = screen_size.x - window.size.x
		var max_y = screen_size.y - window.size.y
		var random_pos = Vector2i(
			randi_range(0, max_x),
			randi_range(0, max_y)
		)
		var tween := create_tween()
		tween.tween_property(window, "position", random_pos, 4.0)
		tween.finished.connect(move_window)


func move_window_to_exact(window_position: Vector2i):
	for enabled_tween in get_tree().get_processed_tweens():
		enabled_tween.stop()
	
	var window := get_window()
	var tween := create_tween()
	tween.tween_property(window, "position", window_position, 2)


func _on_prank_timer_timeout() -> void:
	Sounds.music.seek(0)
	started = false
	for child in get_children():
		if child.is_in_group("b"):
			child.queue_free()
	player.SPEED = 0
	player.start = false
	intro.play("phase 2.5")

func make_bullet_amount(amount: int = 1):
	bulletamount = amount

func GET_THE_FUCK_OUTTA_THERE():
	get_tree().change_scene_to_file("res://scenes/title.tscn")


func win():
	intro.play("DEATH")
	await intro.animation_finished
	Sounds.calm_music()
	GET_THE_FUCK_OUTTA_THERE()

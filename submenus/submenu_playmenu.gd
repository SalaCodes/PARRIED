extends Control

@onready var left: CPUParticles2D = $left
@onready var right: CPUParticles2D = $right
@onready var down: CPUParticles2D = $down


func _ready() -> void:
	if !Settings.particles:
		left.emitting = false
		right.emitting = false
		down.emitting = false


func _on_endless_pressed() -> void:
	Sounds.play_start()
	get_tree().change_scene_to_file("res://scenes/world.tscn")



func _on_go_to_book_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/book.tscn")


func _on_bosses_pressed() -> void:
	get_tree().change_scene_to_file("res://storymode/story_mode_chooser.tscn")


func _on_go_away_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")

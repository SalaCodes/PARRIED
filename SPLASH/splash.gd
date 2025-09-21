extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sounds: AudioStreamPlayer = $sounds

func _ready() -> void:
	sounds.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	animation_player.play("start")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/title.tscn")

extends Control





func _on_tlof_pressed() -> void:
	get_tree().change_scene_to_file("res://storymode/bosses/the_lights_of_hell.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")

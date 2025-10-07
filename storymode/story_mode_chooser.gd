extends Control



func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Cursor.get_node("cursor").play("default")

func _on_tlof_pressed() -> void:
	get_tree().change_scene_to_file("res://storymode/bosses/the_lights_of_hell.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://submenus/submenu_playmenu.tscn")


func _on_dem_ai_n_pressed() -> void:
	get_tree().change_scene_to_file("res://storymode/bosses/dem_ai_n.tscn")

extends Control

@onready var credits: Label = $CREDITS
var quitting = false


func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Cursor.get_node("cursor").play("default")


func _process(delta: float) -> void:
	if !Settings.showcredits:
		credits.visible = false
	else:
		credits.visible = true


func quit():
	get_tree().quit()

func _on_quit_button_pressed() -> void:
	if !quitting:
		quitting = true
		$quit.play("quit")
		await get_tree().create_timer(1.1871).timeout
		Sounds.play_bullet_parry()



func _on_demain_pressed() -> void:
	get_tree().change_scene_to_file("res://demain/demainsthrone.tscn")




func _on_casinobutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/casino.tscn")


func _on_play_pressed() -> void:
	if !quitting:
		get_tree().change_scene_to_file("res://submenus/submenu_playmenu.tscn")


func _on_settings_pressed() -> void:
	if !quitting:
		get_tree().change_scene_to_file("res://scenes/settings.tscn")

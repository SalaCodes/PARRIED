extends Control

@onready var credit_showing: CheckButton = $creditShowing
@onready var credits: Label = $CREDITS
var quitting = false




func _process(delta: float) -> void:
	if !quitting:
		if !credit_showing.button_pressed:
			Credits.showcredits = false
		else:
			Credits.showcredits = true
		
		
		if !Credits.showcredits:
			credits.visible = false
		else:
			credits.visible = true
		
		if Input.is_action_just_pressed("to title"):
			credit_showing.button_pressed = !credit_showing.button_pressed
		
		if !Input.get_connected_joypads().is_empty():
			if Input.is_action_just_pressed("parry"):
				_on_endless_pressed()
			elif Input.is_action_just_pressed("book"):
				_on_go_to_book_pressed()
			elif Input.is_action_just_pressed("dash"):
				_on_characterbutton_pressed()
			elif Input.is_action_just_pressed("pause"):
				_on_info_pressed()
			elif Input.is_action_just_pressed("quit"):
				_on_quit_button_pressed()





func _on_go_to_book_pressed() -> void:
	if !quitting:
		get_tree().change_scene_to_file("res://scenes/book.tscn")


func go_to_characters():
	if !quitting:
		get_tree().change_scene_to_file("res://scenes/character_select.tscn")


func _on_characterbutton_pressed() -> void:
	if !quitting:
		$character.play("gotocharacter")


func _on_info_pressed() -> void:
	if !quitting:
		get_tree().change_scene_to_file("res://scenes/info_page.tscn")

func quit():
	get_tree().quit()


func _on_quit_button_pressed() -> void:
	if !quitting:
		quitting = true
		$quit.play("quit")
		await get_tree().create_timer(1.1871).timeout
		Sounds.play_bullet_parry()


func _on_endless_pressed() -> void:
	if !quitting:
		Sounds.play_start()
		get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_bosses_pressed() -> void:
	get_tree().change_scene_to_file("res://storymode/story_mode_chooser.tscn")


func _on_demain_pressed() -> void:
	get_tree().change_scene_to_file("res://demain/demainsthrone.tscn")

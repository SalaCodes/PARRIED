extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text: RichTextLabel = $Control/text
@onready var text_2: RichTextLabel = $Control/text2



func _process(delta: float) -> void:
	if !Input.get_connected_joypads().is_empty():
		
		var directionl = Input.get_axis("ui_down_controller_left", "ui_up_controller_left")
		if directionl:
			text.get_v_scroll_bar().value -= text.get_v_scroll_bar().step * directionl
		
		var directionr = Input.get_axis("ui_down_controller_right", "ui_up_controller_right")
		if directionr:
			text_2.get_v_scroll_bar().value -= text_2.get_v_scroll_bar().step * directionr
		
		
		if Input.is_action_just_pressed("parry") or Input.is_action_just_pressed("book"):
			_on_button_pressed()


func _on_button_pressed() -> void:
	animation_player.play("reverse_book")


func go_to_title():
	get_tree().change_scene_to_file("res://scenes/title.tscn")

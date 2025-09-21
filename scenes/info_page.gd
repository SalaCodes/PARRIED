extends Control


@onready var text_label: RichTextLabel = $RichTextLabel



func _physics_process(delta: float) -> void:
	if !Input.get_connected_joypads().is_empty():
		var direction = Input.get_axis("ui_down_controller_left", "ui_up_controller_left")
		if direction:
			text_label.get_v_scroll_bar().value -= text_label.get_v_scroll_bar().step * direction
		if Input.is_action_just_pressed("parry"):
			_on_back_pressed()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")

extends AnimatedSprite2D



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	if get_tree().current_scene and get_tree().current_scene.is_in_group("game"):
		play("shield_cursor")
	else:
		play("default")
		rotation = 0
	
	global_position = get_global_mouse_position()

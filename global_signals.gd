extends Node

signal for_animation_ended

func emit_animation_ended():
	for_animation_ended.emit()

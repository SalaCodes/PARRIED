extends Node


signal player_died


func player_dies():
	player_died.emit()

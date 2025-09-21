extends CharacterBody2D
class_name heart

@onready var line_2d: Line2D = $Line2D

func add_second_point(where: Vector2):
	line_2d.add_point(to_local(where))

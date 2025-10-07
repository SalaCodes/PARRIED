extends StaticBody2D

@export var SPEED = 200
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player: CharacterBody2D = $"../player"
	look_at(player.global_position)
	position += transform.x * SPEED * delta
	if global_rotation >= 180:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Sounds.play_hurt()
		queue_free()
		body.damage(1)
		

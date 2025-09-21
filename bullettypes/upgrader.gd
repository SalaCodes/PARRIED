extends StaticBody2D

@export var SPEED = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"..".name == "world" or $"..".name == "THE LIGHTS OF HELL":
		var player: CharacterBody2D = $"../player"
		look_at(player.global_position)
		position += transform.x * SPEED * delta



func _on_area_2d_body_entered(body: Player) -> void:
	if body.is_in_group("player"):
		Sounds.play_heal()
		queue_free()
		body.upgrade_now()
		

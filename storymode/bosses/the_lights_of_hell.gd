extends Node2D


var bullet = preload("res://bullettypes/bullet.tscn")
var helper = preload("res://bullettypes/helper.tscn")
var speeder = preload("res://bullettypes/speeder.tscn")
var upgrader = preload("res://bullettypes/upgrader.tscn")
var looker = preload("res://bullettypes/looker.tscn")
var heart = preload("res://storymode/bossextras/heart.tscn")

@onready var player: Player = $player
@onready var thelightofdeath: Sprite2D = $Area2D/Thelightofdeath
@onready var healthbar: ProgressBar = $CanvasBoss/healthbar
@onready var bulletspawns: Node2D = $bulletspawns
@onready var area_2d_2: Area2D = $Area2D2
@onready var area_2d: Area2D = $Area2D
@onready var tlo_fbody: Sprite2D = $CanvasBoss/TloFbody
@onready var heartconnector: Marker2D = $heartconnector


var bulletamount = 2
var healchance = 100
var speedychance = 5
var upgrade_chance = 150

var lookerexists = false
var lookerNode

var BOSSHEALTH: int = 100

var inside = false
const PARRY_ANGLE_TOLERANCE := 30.0
var invincible = false



func _ready():
	healthbar.min_value = 0
	healthbar.max_value = BOSSHEALTH
	healthbar.value = BOSSHEALTH
	
	var h = heart.instantiate() as heart
	add_child(h)
	var viewport_size = get_viewport_rect().size
	var heart_size = h.get_node("Sprite2D").texture.get_size()
	
	var rand_y = randi() % int(viewport_size.y)
	h.position.y = clamp(rand_y, 0, 140)
	
	h.position.x = randf_range(heart_size.x / 2, viewport_size.x - heart_size.x / 2)
	h.add_second_point(heartconnector.position)
	
	Sounds.uncalm_music()
	Sounds.music.seek(12)
	player.SPEED = Characters.chosen_character["speed"]
	player.start = true



func _exit_tree() -> void:
	Sounds.calm_music()


func _process(delta: float) -> void:
	print(BOSSHEALTH)
	if inside and not invincible:
		if player.velocity != Vector2.ZERO:
			invincible = true
			player.damage(1)
			Sounds.play_hurt()
			player.modulate.a = 3
			await get_tree().create_timer(.6).timeout
			player.modulate.a = 170
			await get_tree().create_timer(.5).timeout
			player.modulate.a = 255
			invincible = false


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "player":
		inside = true


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.name == "player":
		inside = false


func _on_timer_timeout() -> void:
	lookerexists = false
	for i in bulletamount:
		var b
		
		if randi_range(1, upgrade_chance) == 1:
			b = upgrader.instantiate()
		else:
			var GAMBLING = randi_range(1, healchance)
			if GAMBLING == 1:
				b = helper.instantiate()
			else:
				if randi_range(1, speedychance) == 1:
					b = speeder.instantiate()
				else:
					
					lookerNode = get_node_or_null("looker")
					lookerexists = lookerNode != null
					
					if randi_range(1, 100) == 1 and not lookerexists:
						b = looker.instantiate()
					else:
						b = bullet.instantiate()
		
		spawn_bullet(b)

func spawn_bullet(b):
		
	add_child(b)
	var bulletspawn = bulletspawns.get_child(randi_range(0, bulletspawns.get_child_count() - 1))
	
	match b.name:
		"speeder":
			b.SPEED = randf_range(400, 600)
		"bullet":
			b.SPEED = randf_range(150, 250)
		"helper":
			b.SPEED = randf_range(150, 250)
		"upgrader":
			b.SPEED = randf_range(30, 80)
		"looker":
			b.SPEED = 60
			b.name = "looker"
	b.position = bulletspawn.position


func damage(amount: int):
	BOSSHEALTH = max(BOSSHEALTH - amount, 0)
	healthbar.value = BOSSHEALTH
	var h = heart.instantiate() as heart
	call_deferred("add_child", h)
	var viewport_size = get_viewport_rect().size
	var rand_y = randi() % int(viewport_size.y)
	h.position = Vector2(
		randi() % int(viewport_size.x),
		clamp(rand_y, 0, 140)
	)
	h.add_second_point(heartconnector.position)

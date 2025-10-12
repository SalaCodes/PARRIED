extends CharacterBody2D
class_name Player


#ONREADY VARIABLES
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var livestext: Label = $CanvasLayer/livestext
@onready var world: Node2D = $".."
@onready var bg: ColorRect = $"../bg"
@onready var parriestext: Label = $CanvasLayer/parriestext
@onready var upgradelabel: Label = $CanvasLayer/upgradelabel
@onready var upgrade: AnimatedSprite2D = $CanvasLayer/upgrade
@onready var getbackhere: Label = $CanvasLayer/GETBACKHERE
@onready var parry_collision: Area2D = $parryCollision/parryCollision
@onready var dash: AnimatedSprite2D = $CanvasLayer/dash
@onready var dashlabel: Label = $CanvasLayer/dashlabel
@onready var dash_timer: Timer = $dashTimer
@onready var collision_shape_2d: CollisionShape2D = $parryCollision/CollisionShape2D
@onready var shield_parry: Sprite2D = $"parryCollision/Shield(parry)"
@onready var lookerisher_eanimation: AnimationPlayer = $CanvasLayer/LOOKERISHEREanimation
@onready var death_particles: GPUParticles2D = $death_particles
@onready var hplabelthing: Label = $hplabelthing
@onready var heal_animation: AnimationPlayer = $heal
@onready var death: AnimatedSprite2D = %death


#animated players onready variables skins
@onready var default_skin: AnimatedSprite2D = $default
@onready var cat_skin: AnimatedSprite2D = $cat
@onready var armored_skin: AnimatedSprite2D = $armored
@onready var demon_skin: AnimatedSprite2D = $demon



#EXPORT VARIABLES
@export var SPEED: int = 0
@export var health: float = Characters.chosen_character["health"]
@export var max_health: int = Characters.chosen_character["max_health"]
@export var start = false
@export var parries = 0
@export var upgradesChosen = 0
@export var dash_cooldown = 31
@export var dash_speed: float = 8000.0
@export var can_attack = true


# UPGRADES
@export var upgradedgpfd = false # GIVE PARRIES FOR DMG
@export var secondshield = false
@export var upgradeDash = false
@export var upgradehealer = false
var candash = true
var shooting = false


# NORMAL
var health_animation = 0
var lookerexists = false
var lookerNode: Node
var canincreasemaxhp = Characters.chosen_character["canincreasemaxhp"]
var dashactivated = false
var particles = true



func _ready() -> void:
	if !Settings.particles:
		particles = false
	else:
		particles = true
	
	health = max_health
	animation_player.play("upgrade_hide")
	getbackhere.visible = false
	Death.player_died.connect(died)


func _process(delta: float) -> void:
	
	lookerNode = world.get_node_or_null("looker")
	lookerexists = lookerNode != null
	
	if lookerexists:
		lookerisher_eanimation.play("lookerishere")
	else:
		lookerisher_eanimation.play("RESET")
	
	if start:
		if Input.get_connected_joypads().is_empty():
			if not lookerexists:
				$parryCollision.look_at(get_global_mouse_position())
			else:
				$parryCollision.look_at(lookerNode.global_position)
		else:
			var joy_id = Input.get_connected_joypads()[0]
			var right_x = Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_X)
			var right_y = Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_Y)

			var deadzone = 0.2
			if abs(right_x) > deadzone or abs(right_y) > deadzone:
				var dir = Vector2(right_x, right_y)
				
				
				if not lookerexists:
					$parryCollision.rotation = dir.angle()
				else:
					$parryCollision.look_at(lookerNode.global_position)

	dashlabel.text = str("%.2f" % dash_timer.time_left)
	
	Cursor.get_node("cursor").look_at(position)
	
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	parriestext.text = "x " + str(parries)
	upgradelabel.text = "x " + str(upgradesChosen)
	
	if secondshield and not parry_collision.visible:
		parry_collision.visible = true
		var parry = $AnimationPlayer.get_animation("parry")
		parry.track_set_enabled(3, true)
	
	if Input.is_action_just_pressed("parry") and not animation_player.is_playing() and start and can_attack:
		animation_player.play("parry")

	
	if !canincreasemaxhp:
		max_health = Characters.chosen_character["max_health"]
	
	
	if upgradeDash:
		dash.visible = true
		dashlabel.visible = true
	
		if !dashactivated:
			dashlabel.text = "ACTIVATE?"
	
		if Input.is_action_just_pressed("dash") and candash:
			candash = false
			dashactivated = true
			dashlabel.text = "..."  # cooldown state

			var dash_dir = Vector2.RIGHT.rotated(parry_collision.global_rotation) 
			global_position -= dash_dir * dash_speed * delta

			dash_timer.wait_time = dash_cooldown
			dash_timer.start()

			await dash_timer.timeout  # wait for timer
			dashlabel.text = "ACTIVATE?"
			dashactivated = false
			candash = true
	
	character_skin(Characters.chosen_character["skin"])
	death.play(str(health_animation))
	
	if health == 1:
		health_animation = 5
	
	if health <= 0 and world.name == "world":
		health_animation = 0
		Death.player_dies()
		position = $"../playerspawn".position
		parries = 1
		SPEED = 0
		health = Characters.chosen_character["health"]
		upgradesChosen = 0
		max_health = Characters.chosen_character["max_health"]
		var worldchildren = $"..".get_children()
		for child in worldchildren:
			if child.is_in_group("b"):
				child.queue_free()
		$"../Timer".stop()
		Sounds.music.seek(10)
		await get_tree().create_timer(2).timeout
		$"../Timer".start()
		SPEED = Characters.chosen_character["speed"]
	elif health <= 0 and world.is_in_group("BOSS"):
		Sounds.calm_music()
		get_tree().change_scene_to_file("res://storymode/story_mode_chooser.tscn")
	
	
	livestext.text = (str(int(health)) if health == int(health) else str(health)) + "/" + \
	(str(int(max_health)) if max_health == int(max_health) else str(max_health))
	
	if health > max_health:
		health = max_health
	
	move_and_slide()


func _on_parry_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		parries += 1
		play_parry()
		body.queue_free()
	elif body.is_in_group("helper"):
		parries -= 1
		Sounds.play_mistake()
		max_health -= 1
		body.queue_free()
	elif body.is_in_group("upgrader"):
		$"../upgrades".milestone *= 2
	elif body.is_in_group("HEART"):
		world.damage(10)
		body.queue_free()
	


func play_parry():
	Sounds.play_bullet_parry()

func damage(amount):
	health -= amount
	hplabelthing.text = "-" + str(amount)
	heal_animation.stop()
	heal_animation.play("damage")
	if health_animation < 5:
		health_animation += 1
	if upgradedgpfd:
		parries += 1

func heal(amount):
	Sounds.play_heal()
	hplabelthing.text = "+" + str(amount)
	heal_animation.stop()
	heal_animation.play("heal")
	if health != max_health:
		health += amount
		if health_animation > 0:
			health_animation -= 1
	else:
		max_health += 1

func playfor():
	animation_player.play("parry(foranimation)")

func hide_upgrade_ui():
	upgrade.visible = false
	upgradelabel.visible = false


func get_shield_back():
	animation_player.play("get back shield")


func upgrade_show():
	animation_player.play("upgrade_show")

func upgrade_hide():
	animation_player.play("upgrade_hide")

func upgrade_now():
	$"../upgrades".upgrading_time()


func character_skin(char: String):
	default_skin.play("invis")
	cat_skin.play("invis")
	armored_skin.play("invis")
	demon_skin.play("invis")
	
	match char:
		"default":
			default_skin.play(str(health_animation))
		"cat":
			cat_skin.play(str(health_animation))
		"armored":
			armored_skin.play(str(health_animation))
		"demon":
			demon_skin.play(str(health_animation))


func died():
	if particles:
		death_particles_play()
	SoulsHandler.souls += round(parries / 5)
	upgradeDash = false
	upgradedgpfd = false
	secondshield = false
	upgradehealer = false
	parry_collision.visible = false
	dash.visible = false
	dashlabel.visible = false
	$parryCollision/parryCollision/CollisionShape2D.disabled = true
	var parry = $AnimationPlayer.get_animation("parry")
	parry.track_set_enabled(3, false)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	getbackhere.visible = true
	await get_tree().create_timer(.3).timeout
	position = $"../playerspawn".position
	health = 0.5
	Sounds.IMPURE_BLOOD()
	getbackhere.visible = false


func _on_heal_timer_timeout() -> void:
	if upgradehealer and not health == max_health:
		heal(.5)


func reset_animation():
	animation_player.play("RESET")

func hide_shield():
	animation_player.play("everything_disable")

func change_can_attack(boolean: bool):
	can_attack = boolean

func death_particles_play():
	death_particles.emitting = true

func hide_all():
	default_skin.visible = false
	cat_skin.visible = false
	armored_skin.visible = false
	parry_collision.visible = false

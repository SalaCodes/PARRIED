extends Node2D

var bullet = preload("res://bullettypes/bullet.tscn")
var helper = preload("res://bullettypes/helper.tscn")
var speeder = preload("res://bullettypes/speeder.tscn")
var upgrader = preload("res://bullettypes/upgrader.tscn")
var looker = preload("res://bullettypes/looker.tscn")


@onready var bulletspawns: Node2D = $bulletspawns
@onready var timer: Timer = $Timer
@onready var player: Player = $player
@onready var credits: Label = $CREDITS
@onready var sin: AnimationPlayer = $sin

const idk = preload("res://music/Sebastian -vey- Fennec & Ezekiel II - ROBLOX Grace Original Soundtrack (from The Garden) - 08 RETALIATION.mp3")

@export var bulletamount = 1
var basebulletamount = 1
@export var healchance = 100
var basehealchance = 100
@export var speedychance = 5
var baseupgrade_chance = 150
@export var upgrade_chance = 150
var animation = true

var lookerexists = false
var lookerNode

var base_disadvantagemilestone = 100
var disadvantagemilestone = base_disadvantagemilestone



func _ready() -> void:
	if Sounds.music.stream != idk:
		Sounds.uncalm_music()
		play_animation()
	else:
		play_animation()
	
	GlobalSignals.for_animation_ended.connect(ended)
	Death.player_died.connect(died)
	

func _process(delta: float) -> void:
	
	if credits:
		if !Settings.showcredits:
			credits.visible = false
		else:
			credits.visible = true
	
	if Input.is_action_just_pressed("ui_accept"):
		spawn_bullet(looker.instantiate())
	
	if !Input.get_connected_joypads().is_empty():
		if Input.is_action_just_pressed("parry") and animation:
			_on_skip_pressed()
	
	if disadvantagemilestone == player.parries:
		disadvantagemilestone *= 2
		for child in get_children():
			if child.is_in_group("b"):
				child.queue_free()
		timer.paused = true
		player.start = false
		player.SPEED = 0
		sin.play("sin")
		await sin.animation_finished
		bulletamount *= 2
		timer.paused = false
		player.start = true
		player.SPEED = Characters.chosen_character["speed"]
		



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



func _on_skip_pressed() -> void:
	GlobalSignals.emit_animation_ended()
	if $forplayanimation:
		$forplayanimation/skip.visible = false
		Sounds.music.seek(11)
		$forplayanimation/AnimationPlayer.stop()
		$forplayanimation/AnimationPlayer.play("skipped")
		$credits.play("potato")
		timer.autostart = true
		timer.start()
		
		
		await get_tree().create_timer(1).timeout
		
		
		await get_tree().create_timer(.1).timeout
		
		$forplayanimation.queue_free()
		
		
		player.SPEED = Characters.chosen_character["speed"]
		player.start = true
		
		
		


func play_animation():
	if $forplayanimation:
		await get_tree().create_timer(11).timeout
			
		timer.autostart = true
		timer.start()
		
		
		await get_tree().create_timer(1).timeout
		
		
		await get_tree().create_timer(.1).timeout
		
		if $forplayanimation:
			$forplayanimation.queue_free()
		
		$player.SPEED = Characters.chosen_character["speed"]
		$player.start = true

func ended():
	animation = false

func died():
	bulletamount = basebulletamount
	healchance = basehealchance

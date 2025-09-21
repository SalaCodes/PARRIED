extends Node2D

# DUMB SHIT
var music_save_point: float
@onready var player: Player = $"../player"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var card = preload("res://scenes/card.tscn")
@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var upgradesLabel: RichTextLabel = $upgrades


# ACTUAL NERD SHIT
@export var upgrades: Array[Upgrade]
@export var upgradesList: Array
var selected_index := 0
var card_nodes := []
@export var milestone = 10
@export var upgrading = false
var basemilestone = 10


func _ready() -> void:
	Death.player_died.connect(died)


func _process(delta: float) -> void:
	if player.parries == milestone:
		milestone *= 2
		upgrading_time()
	
	
	if Input.get_connected_joypads().is_empty():
		return
	
	
	if Input.is_action_just_pressed("upgradeLeft") and upgrading:
		selected_index = max(0, selected_index - 1)
		_update_highlight()
	elif Input.is_action_just_pressed("upgradeRight") and upgrading:
		selected_index = min(card_nodes.size() - 1, selected_index + 1)
		_update_highlight()

	
	if Input.is_action_just_pressed("parry") and upgrading:
		upgrading = false
		if selected_index < card_nodes.size():
			var upgrade = card_nodes[selected_index].upgrade_data
			_select_upgrade(upgrade)


func spawn_cards():
	# Clear old
	card_nodes.clear()
	selected_index = 0

	# Pick 2 random unique upgrades
	var chosen_upgrades = []
	while chosen_upgrades.size() < 2 and upgrades.size() > 0:
		var upgrade = upgrades[randi() % upgrades.size()]
		if upgrade not in chosen_upgrades:
			chosen_upgrades.append(upgrade)

	# Create cards for chosen upgrades
	for upgrade in chosen_upgrades:
		var c = card.instantiate() as Card
		h_box_container.add_child(c)
		player.get_shield_back()
		c.titleLabel.text = upgrade.title
		c.descriptionLabel.text = upgrade.description
		c.upgrade_data = upgrade
		card_nodes.append(c)
		
		c.card.pressed.connect(func():
			_select_upgrade(upgrade))
	
	_update_highlight()

func _update_highlight() -> void:
	if not Input.get_connected_joypads().is_empty():
		for i in range(card_nodes.size()):
			if !is_instance_valid(card_nodes[i]):
				continue
			if i == selected_index:
				card_nodes[i].modulate = Color(1, 1, 0.5)  # highlight
			else:
				card_nodes[i].modulate = Color(1, 1, 1)    # normal


func _select_upgrade(upgrade):
	for child in h_box_container.get_children():
		child.visible = false
	upgradesList.append(upgrade.title)
	print(upgradesList)
	player.upgradesChosen += 1
	animation_player.stop()
	await get_tree().create_timer(0.1).timeout

	match upgrade.title:
		"PRAYED UPON":
			player.upgradedgpfd = true
			upgrades.erase(upgrade)
		"TWICE THE GAMBLE":
			$"..".bulletamount *= 2
			upgrades.erase(upgrade)
		"HEAL FOR LIFE":
			if $"..".healchance <= 80:
				$"..".healchance = 80
				upgrades.erase(upgrade)
			else:
				$"..".healchance -= 2
		"TWICE THE POWER":
			player.secondshield = true
			upgrades.erase(upgrade)
		"PRAYED FAST":
			player.SPEED += 10
		"DASH":
			player.upgradeDash = true
			player.dash_cooldown -= 1
			if player.dash_cooldown <= 10:
				player.dash_cooldown = 10
				upgrades.erase(upgrade)
		"HEALER":
			player.upgradehealer = true
			upgrades.erase(upgrade)
		"DEATH TO SPEED":
			$"..".speedychance += 1

	# clear cards and resume game
	
	animation_player.play_backwards("upgrade_animation")
	await animation_player.animation_finished
	
	player.start = true
	player.get_shield_back()
	Sounds.uncalm_music()
	Sounds.music.seek(music_save_point)
	player.upgrade_hide()
	$Area2D/CollisionShape2D.disabled = false
	get_tree().paused = false
	upgrading = false
	$upgrades.visible = false
	await get_tree().create_timer(0.1).timeout
	$Area2D/CollisionShape2D.disabled = true
	player.reset_animation()
	player.hide_upgrade_ui()
	
	update_upgrade_text()
	
	for child in h_box_container.get_children():
		child.queue_free()
	for child in get_children():
		if child.name == "RECT":
			child.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		body.queue_free()


func upgrading_time():
	
	update_upgrade_text()
	
	upgrading = true
	$upgrades.visible = true
	spawn_cards()
	player.get_shield_back()
	player.upgrade_show()
	animation_player.get_animation("upgrade_animation").track_insert_key(0, 0, player.position)
	player.start = false
	
	music_save_point = Sounds.music.get_playback_position()
	animation_player.play("upgrade_animation")
	get_tree().paused = true
	Sounds.calm_music()



func update_upgrade_text():
	upgradesLabel.text = "upgrades:\n"
	var upgrade_counts := {}
		
	# Count each upgrade in upgradesList
	for upgrade in upgradesList:
		if not upgrade_counts.has(upgrade):
			upgrade_counts[upgrade] = 1
		else:
			upgrade_counts[upgrade] += 1
		
	# Now build the text
	for upgrade in upgrade_counts.keys():
		var count = upgrade_counts[upgrade]
		if count > 1:
			upgradesLabel.text += "%s x%d\n" % [upgrade, count]
		else:
			upgradesLabel.text += "%s\n" % upgrade



func died():
	upgradesList.clear()
	milestone = basemilestone
	selected_index = 0
	card_nodes = []
	upgrading = false

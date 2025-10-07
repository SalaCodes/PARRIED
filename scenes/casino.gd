extends Control

@onready var gamble_text: Label = $gamble_text
@onready var dealer_text: RichTextLabel = $dealer_text
@onready var gamble: TextureButton = $gamble
@onready var animation_player: AnimationPlayer = $hand_animation
@onready var hand: AnimatedSprite2D = $hand
@onready var audio_player = $sfx
@onready var music: AudioStreamPlayer = $music
@onready var souls_animation: AnimationPlayer = $souls_animation
@onready var souls_label_gamble: Label = $souls_label_gamble
@onready var souls_label: Label = $souls_label
@onready var current_character: Label = $current_character
@onready var go_away: TextureButton = $"go away"

var pressure_font: FontFile = preload("res://fonts/pressure_font.ttf")


var gamble_time = .5
var gambled_character
var randomnumber



func _ready() -> void:
	
	
	dealer_text.bbcode_enabled = true
	gamble.disabled = true
	await get_tree().process_frame  # Wait one frame to ensure we're in the scene tree
	Sounds.music.stream_paused = true
	music.play()
	music.seek(2.4)
	gamble.disabled = false



func _process(delta: float) -> void:
	
	current_character.text = "CURRENT CHARACTER: " + str(Characters.chosen_character["skin"]).to_upper()
	
	souls_label.text = str(SoulsHandler.souls)
	
	if Input.is_action_just_pressed("tabdebug"):
		dealer_texts()


func _on_gamble_pressed() -> void:
	if SoulsHandler.souls >= 50:
		gamble.disabled = true
		go_away.disabled = true
		souls_animation.play("souls")
		souls_label_gamble.text = "-50 souls"
		SoulsHandler.souls -= 50
		play_hand()
		await get_tree().create_timer(1).timeout
		for i in range(1, 6):
			for upgrades in Characters.characters:
				gamble_text.text = upgrades["skin"].to_upper()
				await get_tree().create_timer(gamble_time).timeout
				gamble_time -= .05
		
		randomnumber = randi_range(0, Characters.characters.size() - 1)
		gamble_time = .5
		
		gambled_character = Characters.characters.get(randomnumber)
		if !gambled_character:
			dealer_text.text = "something went wrong..... giving souls back...."
			souls_animation.play("souls")
			souls_label_gamble.text = "+50 souls"
			SoulsHandler.souls += 50
		else:
			gamble_text.text = gambled_character["skin"].to_upper()
			if gambled_character == Characters.chosen_character:
				souls_animation.play("souls")
				souls_label_gamble.text = "+20 souls"
				SoulsHandler.souls += 20
				dealer_text.text = "another one huh? Unlucky....."
				show_next_letter()
			else:
				Characters.chosen_character = gambled_character
				Characters.save_chosen_character(gambled_character["skin"])
				
				match Characters.chosen_character["skin"]:
					"default":
						dealer_text.text = "huh..... this one is the mere basics...."
						show_next_letter()
					"cat":
						dealer_text.text = "9 max health and health... faster... can't get extra max health.... I think?"
						show_next_letter()
						if !gamble.disabled:
							dealer_text.text = "I don't know why i sell this one..."
							show_next_letter()
					"armored":
						dealer_text.text = "15 health... but slow as f__k"
						show_next_letter()
					"demon":
						dealer_text.text = "ONE OF US!"
						show_next_letter()
		
	else:
		dealer_texts()
		
		if get_tree() != null:
			await safe_wait(3)
			go_away.disabled = false
		


func safe_wait(seconds: float) -> void:
	if get_tree():
		await get_tree().create_timer(seconds).timeout



func dealer_texts():
	dealer_text.add_theme_font_override("pressure", pressure_font)
	dealer_text.text = ""
	match randi_range(1, 15):
		1:
			dealer_text.text = "[color=#ff0000]souls........ [/color]please..."
			show_next_letter()
		2:
			dealer_text.text = "feed me..... [color=#ff0000]SOULS[/color]"
			show_next_letter()
		3:
			dealer_text.text = "ugh... need... [color=#ff0000]souls.... NOW[/color]"
			show_next_letter()
		4:
			gamble_text.text = "CAT..... just kidding"
			dealer_text.text = "YOU GOT THE CAT! that's a lie, now give me [color=#ff0000]souls[/color]"
			show_next_letter()
		5:
			dealer_text.text = "[color=#0866ff]Saladin[/color]? What an ugly name....."
			show_next_letter()
		6:
			dealer_text.text = "Wow..... you think you can just waltz in here without [color=#ff0000]SOULS[/color]? [color=#4d0004]GET OUT[/color]"
			show_next_letter()
			await get_tree().create_timer(4.6).timeout
			Sounds.play_bullet_parry()
			Sounds.music.stream_paused = false
			get_tree().change_scene_to_file("res://scenes/title.tscn")
		7:
			dealer_text.text = "You think this is a game? This is life buddy... I... [color=#dbc500]think...[/color]..."
			show_next_letter()
		8:
			dealer_text.text = "OH A CUSTOMER! Nevermind it's a [color=#ff0000]bullet....[/color]"
			show_next_letter()
		9:
			dealer_text.text = "'Parry the [color=#ff0000]bullets[/color]' they said, 'it'll get you out of here' they said."
			show_next_letter()
		10:
			gamble_text.text = "WILL TO LIVE"
			dealer_text.text = "YOU GOT A WILL TO [color=#ff0000]LIVE[/color]...... unlike me...."
			show_next_letter()
		11:
			dealer_text.text = "Those [color=#ff0000]bullets[/color] that force you to look are terrifying...."
			show_next_letter()
		12:
			dealer_text.text = "Do you like the sign I made? Nevermind it's [color=#ff0000]stupid.[/color]..."
			show_next_letter()
		13:
			dealer_text.text = "Are you feeling the [font=pressure][color=#ff0000]PRESSURE[/color][/font].....?"
			show_next_letter()
		14:
			dealer_text.text = "Is [color=#ff0000]SHE[/color] here?"
			show_next_letter()
		15:
			dealer_text.text = "[color=#ff0000]Demain[/color] killed my friend.... I hope she burns in [color=#ff0000]hell...[/color] wait we are already in [color=#ff0000]hell...[/color]"
			show_next_letter()



func play_hand():
	animation_player.play("hand")
	await get_tree().create_timer(1).timeout
	hand.play("default")


func _on_go_away_pressed() -> void:
	gamble.disabled = true
	go_away.disabled = true
	animation_player.play("leave")
	dealer_text.position.y -= 250
	dealer_text.text = "Going away already? Now I have to put everything away..."
	show_next_letter()
	await get_tree().create_timer(4).timeout
	music.stop()
	Sounds.music.stream_paused = false
	get_tree().change_scene_to_file("res://scenes/title.tscn")


func show_next_letter(speed := 0.06):
	gamble.disabled = true
	go_away.disabled = true

	dealer_text.bbcode_enabled = true
	var full_text = dealer_text.text
	dealer_text.text = full_text  # Set the full BBCode text

	dealer_text.visible_ratio = 0.0  # Start with no visible characters

	var total_chars = dealer_text.get_total_character_count()
	var reveal_step = 1.0 / total_chars

	for i in range(total_chars):
		dealer_text.visible_ratio = (i + 1) * reveal_step
		audio_player.stop()
		audio_player.play()
		await get_tree().create_timer(speed).timeout

	go_away.disabled = false
	gamble.disabled = false

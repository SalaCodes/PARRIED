extends Node2D

@onready var demainspeech: RichTextLabel = $demainspeech
@onready var sfx: AudioStreamPlayer = $sfx
@onready var timer: Timer = $Timer

var talking = false
var lastnumber: int
var number: int

func _ready() -> void:
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_next_letter(speed := 0.06):
	talking = true
	var full_text = demainspeech.text
	demainspeech.text = ""
	var segments = []
	var buffer = ""
	var inside_tag = false

	for i in range(full_text.length()):
		var c = full_text[i]
		if c == "[":
			if buffer != "":
				segments.append({"type": "text", "content": buffer})
				buffer = ""
			inside_tag = true
			buffer += c
		elif c == "]":
			buffer += c
			segments.append({"type": "tag", "content": buffer})
			buffer = ""
			inside_tag = false
		else:
			buffer += c

	if buffer != "":
		var t = "tag" if inside_tag else "text"
		segments.append({"type": t, "content": buffer})

	# Count total visible characters (only from "text" segments)
	var total_visible = 0
	for seg in segments:
		if seg["type"] == "text":
			total_visible += seg["content"].length()

	# Reveal one visible character at a time
	var revealed_count = 0
	while revealed_count < total_visible:
		var target = revealed_count + 1  # how many visible chars to show now
		var output = ""
		var seen = 0

		for seg in segments:
			if seg["type"] == "tag":
				# always include tags fully so formatting is applied
				output += seg["content"]
			else:
				var seg_text = seg["content"]
				var seg_len = seg_text.length()
				if seen + seg_len <= target:
					# include whole segment
					output += seg_text
				elif seen < target:
					# include only a prefix of this segment
					output += seg_text.substr(0, target - seen)
				# else include none from this segment yet
				seen += seg_len

		demainspeech.text = output
		sfx.stop()
		sfx.play()
		await get_tree().create_timer(speed).timeout
		revealed_count += 1
	talking = false
	timer.stop()
	timer.start()


func _on_timer_timeout() -> void:
	if !talking:
		number = randi_range(1, 7)
		while number == lastnumber:
			number = randi_range(1, 7)
		lastnumber = number
		match number:
			1:
				demainspeech.text = "A [color=#0036a3]dealer[/color] huh? Didn't I [color=#630000]kill[/color] his friend or something?"
				show_next_letter()
			2:
				demainspeech.text = "I AM [color=#ff0000]DEMAIN[/color], QUEEN OF THIS PLACE..... [color=#ff0000]PARRIED[/color] is my playtown, and you citizens are my [color=#0c008c]playthings....[/color]"
				show_next_letter()
			3:
				demainspeech.text = "[color=#bd0000]You are below me.[/color]"
				show_next_letter(0.2)
			4:
				demainspeech.text = "How did you get so many [color=#ff0000]souls?[/color]"
				show_next_letter()
			5:
				demainspeech.text = "[color=#1c8c00]Mercy?[/color] What is that?"
				show_next_letter()
			6:
				demainspeech.text = "WELCOME TO [color=#ff0000]HELL[/color]... oh it's [color=#0036a3]you[/color]"
				show_next_letter()
			7:
				demainspeech.text = "[color=#0c008c]Pressure?[/color] Like when I push something?"
				show_next_letter()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")

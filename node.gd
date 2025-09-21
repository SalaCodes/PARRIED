extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var music: AudioStreamPlayer = $music

const BOOM_17 = preload("res://sounds/Boom17.wav")
const HIT_39 = preload("res://sounds/Hit39.wav")
const BOOM_18 = preload("res://sounds/Boom18.wav")
const BOOM_19 = preload("res://sounds/Boom19.wav")
const POWER_UP_6 = preload("res://sounds/PowerUp6.wav")
const BOOM_41 = preload("res://sounds/Boom41.wav")

const uncalm = preload("res://music/Sebastian -vey- Fennec & Ezekiel II - ROBLOX Grace Original Soundtrack (from The Garden) - 08 RETALIATION.mp3")
const calm = preload("res://music/Sebastian -vey- Fennec - ROBLOX Grace Original Soundtrack (from The Garden) - 01 -BONUS- ...Let us Pray..mp3")

func _ready() -> void:
	calm_music()




func play_bullet_parry():
	autoplay(false)
	audio_stream_player.stream = BOOM_17
	audio_stream_player.volume_db = 0
	audio_stream_player.play()

func play_hurt():
	autoplay(false)
	audio_stream_player.stream = HIT_39
	audio_stream_player.volume_db = 12
	audio_stream_player.play()

func play_start():
	autoplay(false)
	audio_stream_player.stream = BOOM_18
	audio_stream_player.volume_db = 0
	audio_stream_player.play()

func play_mistake():
	autoplay(false)
	audio_stream_player.stream = BOOM_19
	audio_stream_player.volume_db = 0
	audio_stream_player.play()

func play_heal():
	autoplay(false)
	audio_stream_player.stream = POWER_UP_6
	audio_stream_player.volume_db = 0
	audio_stream_player.play()

func IMPURE_BLOOD():
	autoplay(false)
	audio_stream_player.stream = BOOM_41
	audio_stream_player.volume_db = 24
	audio_stream_player.play()

func calm_music():
	autoplay(true)
	music.stream = calm
	music.play()

func uncalm_music():
	autoplay(true)
	music.stream = uncalm
	music.play()

func autoplay(boolean: bool):
	audio_stream_player.autoplay = boolean
	music.autoplay = boolean


func _on_music_finished() -> void:
	music.play()

extends Control

var showcredits = Settings.showcredits
var showparticles = Settings.particles

@onready var credits: CheckBox = $HBoxContainer/VBoxContainer/credits
@onready var particles: CheckBox = $HBoxContainer/VBoxContainer/particles


func _ready() -> void:
	# INITIALIZE BUTTONS
	credits.button_pressed = showcredits
	particles.button_pressed = showparticles


func _process(delta: float) -> void:
	# CHANGE IN SCRIPT VALUE
	showcredits = credits.button_pressed
	showparticles = particles.button_pressed
	
	
	# CHANGE GLOBAL VALUE
	Settings.showcredits = showcredits
	Settings.particles = showparticles


func _on_go_away_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")

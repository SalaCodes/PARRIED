extends Control

var showcredits = Settings.showcredits
var showparticles = Settings.particles
var showfps = Settings.showfps

@onready var credits: CheckBox = $HBoxContainer/VBoxContainer/credits
@onready var particles: CheckBox = $HBoxContainer/VBoxContainer/particles
@onready var fpscounter: CheckBox = $HBoxContainer/VBoxContainer/fpscounter


func _ready() -> void:
	# INITIALIZE BUTTONS
	credits.button_pressed = showcredits
	particles.button_pressed = showparticles
	fpscounter.button_pressed = showfps


func _process(delta: float) -> void:
	# CHANGE IN SCRIPT VALUE
	showcredits = credits.button_pressed
	showparticles = particles.button_pressed
	showfps = fpscounter.button_pressed
	
	
	# CHANGE GLOBAL VALUE
	Settings.showcredits = showcredits
	Settings.particles = showparticles
	Settings.showfps = showfps

func _on_go_away_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")

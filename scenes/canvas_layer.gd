extends CanvasLayer


var paused = false
@onready var rich_text_label: CanvasLayer
@onready var upgrades: RichTextLabel
@onready var upgradesNode: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	if $"../canvasDebug":
		rich_text_label = $"../canvasDebug"
	if $"../upgrades/upgrades":
		upgrades = $"../upgrades/upgrades"
	if $"../upgrades":
		upgradesNode = $"../upgrades"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	paused = get_tree().paused
	
	if Input.is_action_just_pressed("pause") and not paused:
		if upgradesNode:
			if not upgradesNode.upgrading:
				upgrades.visible = true
				rich_text_label.visible = true
				visible = true
				get_tree().paused = true
				Sounds.music.stream_paused = true
				return
		else:
			if rich_text_label:
				rich_text_label.visible = true
			visible = true
			get_tree().paused = true
			Sounds.music.stream_paused = true
			return
			
		
	
	if Input.is_action_just_pressed("pause") and paused:
		if upgradesNode:
			upgrades.visible = false
		if rich_text_label:
			rich_text_label.visible = false
		visible = false
		get_tree().paused = false
		Sounds.music.stream_paused = false
	
	
	
	if Input.is_action_just_pressed("continue"):
		_on_continue_pressed()
	elif Input.is_action_just_pressed("quit"):
		_on_quit_pressed()
	elif Input.is_action_just_pressed("to title"):
		_on_go_back_pressed()


func _on_continue_pressed() -> void:
	if upgradesNode:
		upgrades.visible = false
	if rich_text_label:
		rich_text_label.visible = false
	visible = false
	get_tree().paused = false
	Sounds.music.stream_paused = false


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_go_back_pressed() -> void:
	get_tree().paused = false
	Sounds.music.stream_paused = false
	visible = false
	Sounds.calm_music()
	$"../player".health = 0
	get_tree().change_scene_to_file("res://scenes/title.tscn")

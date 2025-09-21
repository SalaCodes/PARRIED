extends CanvasLayer

@export var speed: int
@export var next_upgrade: int
@export var health: float
@export var max_health: int
@export var parries: int
@export var upgrade: int
@export var souls: int


@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var player: Player = $"../player"
@onready var upgrades_node: Node2D = $"../upgrades"



func _process(delta: float) -> void:
	
	if player:
		speed = player.SPEED
		next_upgrade = upgrades_node.milestone - player.parries
		health = player.health
		max_health = player.max_health
		parries = player.parries
		upgrade = player.upgradesChosen
		souls = SoulsHandler.souls
		
		
		rich_text_label.text = "DEBUG: \n \n speed: " + str(speed) + "\n next upgrade: " + str(next_upgrade) \
		+ "\n health: " + str(health) + "\n max_health: " + str(max_health) + "\n parries: " + str(parries) \
		+ "\n upgrades: " + str(upgrade) + "\n souls: " + str(souls)



func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("tabdebug"):
		visible = !visible
	

extends Control
class_name Card

@onready var titleLabel: Label = %title
@onready var descriptionLabel: Label = %description
@onready var card: Button = $card
@export var upgrade_data: Upgrade
@export var title: String
@export_multiline var description: String

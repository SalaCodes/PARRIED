extends CanvasLayer

@onready var label: Label = $Label

func _process(delta: float) -> void:
	label.text = str("%0.3f" % (1.0 / delta)) + " fps"
	
	if Settings.showfps:
		visible = true
	else:
		visible = false

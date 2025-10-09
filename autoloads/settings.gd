extends Node


var showcredits = true
var particles = true


func _ready() -> void:
	if FileAccess.file_exists(SoulsHandler.SAVE_PATH):
		var data = SoulsHandler.load_data()
		showcredits = data.get("showcredits", true)
		particles = data.get("particles", true)


func _process(delta: float) -> void:
	
	var data = {
		"showcredits": showcredits,
		"particles": particles,
	}
	
	
	SoulsHandler.save_data(data)

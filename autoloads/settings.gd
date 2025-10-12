extends Node


var showcredits = true
var particles = true
var showfps = false


func _ready() -> void:
	if FileAccess.file_exists(SoulsHandler.SAVE_PATH):
		var data = SoulsHandler.load_data()
		showcredits = data.get("showcredits", true)
		particles = data.get("particles", true)
		showfps = data.get("showfps", false)


func _process(delta: float) -> void:
	
	var data = {
		"showcredits": showcredits,
		"particles": particles,
		"showfps": showfps,
	}
	
	
	SoulsHandler.save_data(data)

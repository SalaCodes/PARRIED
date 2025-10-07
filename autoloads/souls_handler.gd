extends Node

var souls: int
const SAVE_PATH := "user://save_data.parried"

func _ready() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		load_data()
	else:
		souls = 0
		save_data({"souls": souls})

func _process(delta: float) -> void:
	save_data({"souls": souls})


func save_data(new_data: Dictionary) -> void:
	var merged_data: Dictionary = {}
	
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var existing_data = file.get_var()
		file.close()
		
		if typeof(existing_data) == TYPE_DICTIONARY:
			merged_data = existing_data.duplicate()
	
	for key in new_data.keys():
		merged_data[key] = new_data[key]
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(merged_data)
	file.close()


func load_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_var()
	file.close()
	
	if typeof(data) != TYPE_DICTIONARY:
		data = {}
	
	souls = data.get("souls", 0)
	
	return data

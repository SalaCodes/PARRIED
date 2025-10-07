extends Node

# Predefined characters
const DEFAULT: Dictionary = {
	"skin": "default",
	"health": 5,
	"max_health": 5,
	"speed": 300,
	"canincreasemaxhp": true,
}

const CAT: Dictionary = {
	"skin": "cat",
	"health": 9,
	"max_health": 9,
	"speed": 500,
	"canincreasemaxhp": false,
}

const ARMORED: Dictionary = {
	"skin": "armored",
	"health": 15,
	"max_health": 15,
	"speed": 150,
	"canincreasemaxhp": false,
}

const DEMON: Dictionary = {
	"skin": "demon",
	"health": 8,
	"max_health": 13,
	"speed": 400,
	"canincreasemaxhp": true,
}


var characters: Array = [DEFAULT, CAT, ARMORED, DEMON]

var chosen_character_key: String = "default"
var chosen_character: Dictionary = DEFAULT

func _ready() -> void:
	var data = SoulsHandler.load_data()

	if data.has("chosen_character"):
		# Look for the character in the array by its "skin" key
		for char in characters:
			if char["skin"] == data["chosen_character"]:
				chosen_character = char
				chosen_character_key = char["skin"]
				break
	else:
		save_chosen_character(chosen_character_key)

	print("Chosen character:", chosen_character_key)
	print(chosen_character)


func save_chosen_character(key: String) -> void:
	# Find the character in the array
	for char in characters:
		if char["skin"] == key:
			chosen_character = char
			chosen_character_key = key
			break

	# Save to file
	var data = SoulsHandler.load_data()
	data["chosen_character"] = key
	SoulsHandler.save_data(data)

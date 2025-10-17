extends Node

class_name C_Loader

func load_all() -> PackedStringArray:
	var config = ConfigFile.new()
	var err = config.load("user://characters/characters.cfg")
	if err != OK:
		print("aaaaaa: ", err)

	return config.get_section_keys("characters")

func load_c_image(character: String) -> Array: 
	# this returns specifically an array that has a Texture2d, int, int
	var config = ConfigFile.new()
	var err = config.load("res://characters/"+character+"/"+character+".cfg")
	
	return [
		load("res://characters/"+ config.get_value("meta", "name") + "/" + config.get_value("meta", "image")),
		config.get_value("meta", "hb_width"),
		config.get_value("meta", "hb_height")
	]

extends Node

class_name C_Loader

func load_all() -> PackedStringArray:
	var config = ConfigFile.new()
	var err = config.load("user://characters/characters.cfg")
	if err != OK:
		print("aaaaaa: ")

	return config.get_section_keys("characters")

func load_char(charac: String) -> Dictionary: 
	# this returns specifically an array that has a Texture2d, int, int
	var config = ConfigFile.new()
	var err = config.load("user://characters/"+charac+"/"+charac+".cfg")
	if err != OK:
		return {}
	var path = "user://characters/"+ config.get_value("meta", "name") + "/"
	return {
		"base_image": load(path + config.get_value("meta", "image")),
		"hb_width": config.get_value("meta", "hb_width", 32),
		"hb_height": config.get_value("meta", "hb_height", 32),
		"scalex": config.get_value("meta", "scalex", 1.0),
		"scaley": config.get_value("meta", "scaley", 1.0),
		"speed": config.get_value("stats", "speed", 200),
		"jump": config.get_value("stats", "jump", -400),
		"idle_anim_folder": config.get_value("anim", "idle_folder", "idle"),
		"idle_anim_frames": config.get_value("anim", "idle_frames", 1),
		"run_anim_folder": config.get_value("anim", "run_folder", "run"),
		"run_anim_frames": config.get_value("anim", "run_frames", 1),
		"norm_attack_type": config.get_value("normal", "type", "melee"),
		"norm_anim_folder": config.get_value("normal", "anim", "normal"),
		"norm_anim_frames": config.get_value("normal", "frames"),
		"norm_attack_damage": config.get_value("normal", "damage", 5),
		"norm_sizex": config.get_value("normal", "sizex", 32),
		"norm_sizey": config.get_value("normal", "sizey", 32)
		
	}

	

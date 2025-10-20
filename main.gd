extends Node2D

var character_base = preload("res://player.tscn")
var loader = C_Loader.new()
var chars: PackedStringArray = loader.load_all()
var current: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.joy_connection_changed.connect(on_gamepad_connected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Label.text = chars[current]
	pass

func _on_spawn_pressed() -> void:
	spawn()

func _on_next_pressed() -> void:
	if !(current==len(chars)-1):
		current += 1

func _on_prev_pressed() -> void:
	if !(current==0):
		current -= 1

func on_gamepad_connected(device, controller) ->void:
	Global.allControllers = Input.get_connected_joypads()
	print(Global.allControllers)

func spawn() -> void:
	var path = "user://characters/"+ chars[current] + "/"
	var a: Player = character_base.instantiate()
	
	var data: Dictionary = loader.load_char(chars[current])
	
	var animSprite: AnimatedSprite2D = a.get_node("AnimatedSprite2D")
	var sframes: SpriteFrames = SpriteFrames.new()
	
	sframes.add_animation("idle")
	for i in range(data["idle_anim_frames"]):
		var im = Image.new()
		sframes.add_frame("idle", ImageTexture.create_from_image(im.load_from_file(path + "anim/" + data["idle_anim_folder"] + "/idle" + str(i+1) + ".png")))
	
	sframes.add_animation("run")
	for i in range(data["run_anim_frames"]):
		var im = Image.new()
		sframes.add_frame("run", ImageTexture.create_from_image(im.load_from_file(path + "anim/" + data["run_anim_folder"] + "/run" + str(i+1) + ".png")))
	
	animSprite.set_sprite_frames(sframes)
	
	
	
	var aShape: RectangleShape2D = RectangleShape2D.new()
	aShape.size = Vector2(data["hb_width"], data["hb_height"])
	a.get_node("CollisionShape2D").set_shape(aShape)
	
	a.SPEED = data["speed"]
	a.JUMP_VELOCITY = data["jump"]
	a.scale = Vector2(data["scalex"], data["scaley"])
	add_child(a)

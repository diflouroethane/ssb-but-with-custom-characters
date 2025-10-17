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
	#$CanvasLayer/Label.text = chars[current]
	pass

func _on_spawn_pressed() -> void:
	var a: Player = character_base.instantiate()
	var aShape: RectangleShape2D = RectangleShape2D.new()
	var data: Array = loader.load_c_image(chars[current])
	a.get_node("Sprite2D").texture = data[0]
	#set_props(a, chars[current])
	aShape.size = Vector2(data[1], data[2])
	a.get_node("CollisionShape2D").set_shape(aShape)
	print(a.get_node("CollisionShape2D"))
	add_child(a)
	

func set_props(player: Player, character: String):
	pass

func _on_next_pressed() -> void:
	if !(current==len(chars)-1):
		current += 1

func _on_prev_pressed() -> void:
	if !(current==0):
		current -= 1

func on_gamepad_connected(device, controller) ->void:
	Global.allControllers = Input.get_connected_joypads()
	print(Global.allControllers)

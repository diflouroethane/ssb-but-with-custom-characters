extends CharacterBody2D

class_name Player

var loader: C_Loader = C_Loader.new()
const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
var extA: float
var extB: float
var index: int
var controller: int
var jump

var bindings: Dictionary = {
	"left": JOY_BUTTON_DPAD_LEFT,
	"right": JOY_BUTTON_DPAD_RIGHT,
	"up": JOY_BUTTON_DPAD_UP,
	"down": JOY_BUTTON_DPAD_DOWN,
	"jump": JOY_BUTTON_A
}

func _ready() -> void:
	Global.allPlayers.append(self)
	index = Global.allPlayers.find(self)
	controller = Input.get_connected_joypads()[index]
	print(index)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	jump = Input.is_joy_button_pressed(controller, bindings["jump"])
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if jump and is_on_floor():
		
		velocity.y = JUMP_VELOCITY
		jump = false

	if Input.is_joy_button_pressed(controller, bindings["left"]):
		velocity.x = -SPEED
	elif Input.is_joy_button_pressed(controller, bindings["right"]):
		velocity.x = SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func set_props(character: String):
	var data: Array = loader.load_c_image(character)
	$Sprite2D.texture = data[0]
	var shape: Shape2D = $CollisionShape2D.shape
	shape.size =Vector2(data[1]/2, data[2]/2)

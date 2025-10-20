extends CharacterBody2D

class_name Player

var SPEED: float
var JUMP_VELOCITY: float
var extA: float
var extB: float
var index: int
var controller: int
var attack_types: Array = ["melee", "ranged"]

# normal attack
var norm_type: String
var norm_damage: int

# special attack
var spec_type: String
var spec_damage: int

var bindings: Dictionary = {
	"left": JOY_BUTTON_DPAD_LEFT,
	"right": JOY_BUTTON_DPAD_RIGHT,
	"up": JOY_BUTTON_DPAD_UP,
	"down": JOY_BUTTON_DPAD_DOWN,
	"jump": JOY_BUTTON_RIGHT_SHOULDER,
	"normalattack": JOY_BUTTON_A,
	"specialattack": JOY_BUTTON_B
}

func _ready() -> void:

	Global.allPlayers.append(self)
	index = Global.allPlayers.find(self)
	controller = Input.get_connected_joypads()[index]
	$AnimatedSprite2D.play("idle")
	print(index)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if Input.is_joy_button_pressed(controller, bindings["jump"]) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_joy_button_pressed(controller, bindings["left"]):
		velocity.x = -SPEED
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = true
	elif Input.is_joy_button_pressed(controller, bindings["right"]):
		velocity.x = SPEED
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()

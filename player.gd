extends CharacterBody2D

class_name Player

var loader: C_Loader = C_Loader.new()
const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
var extA
var extB

func _ready() -> void:
	#$CollisionShape2D.shape.size = Vector2(extA,extB)
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func set_props(character: String):
	var data: Array = loader.load_c_image(character)
	$Sprite2D.texture = data[0]
	var shape: Shape2D = $CollisionShape2D.shape
	shape.size =Vector2(data[1]/2, data[2]/2)

extends CharacterBody2D

class_name Player

var SPEED: float
var JUMP_VELOCITY: float
var extA: float
var extB: float
var index: int
var controller: int
var dir: String
var attack_types: Array = ["melee", "ranged"]
var melee: PackedScene = preload("res://melee_attack.tscn")
var leftPos: Vector2
var rightPos: Vector2
enum playerState {RUN, IDLE, NORMAL}
var state: playerState = playerState.IDLE

# normal attack
var norm_type: String
var norm_damage: int
var norm_sizex: int
var norm_sizey: int

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

var _recoiling: bool = false
var recoil_speed: float = 10000.0

func _ready() -> void:
	dir = "left"
	Global.allPlayers.append(self)
	index = Global.allPlayers.find(self)
	controller = Input.get_connected_joypads()[index] 
	$AnimatedSprite2D.centered = false
	$AnimatedSprite2D.offset = Vector2(-$CollisionShape2D.get_shape().size.x/2, -$CollisionShape2D.get_shape().size.y/2)
	$AnimatedSprite2D.play("idle")
	
	leftPos = Vector2(-$CollisionShape2D.get_shape().size.x/2-$CollisionShape2D.get_shape().size.x/2, -$CollisionShape2D.get_shape().size.y/2)
	rightPos = Vector2(-$CollisionShape2D.get_shape().size.x/2, -$CollisionShape2D.get_shape().size.y/2)
	print(index)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if Input.is_joy_button_pressed(controller, bindings["jump"]) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if state == playerState.RUN:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.offset = rightPos
	elif state == playerState.IDLE:
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.offset = rightPos
	elif state == playerState.NORMAL:
		$AnimatedSprite2D.play("normal")
		
	if Input.is_joy_button_pressed(controller, bindings["left"]):
		velocity.x = -SPEED
		$AnimatedSprite2D.flip_h = true
		dir = "left"
		state = playerState.RUN
	elif Input.is_joy_button_pressed(controller, bindings["right"]):
		velocity.x = SPEED
		$AnimatedSprite2D.flip_h = false
		dir = "right"
		state = playerState.RUN
	elif not _recoiling:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		state=playerState.IDLE
	
	if _recoiling:
		velocity.x = move_toward(velocity.x, recoil_speed, 1000)
	
	if Input.is_joy_button_pressed(controller, bindings["normalattack"]):
		attack(dir)
	
	move_and_slide()

func attack(_direction: String) -> void:
	var att: MeleeAttack = melee.instantiate()
	att.parent = self
	
	att.get_node("Collision").shape.size = Vector2(norm_sizex, norm_sizey)
	state = playerState.NORMAL
	if dir == "left":
		$AnimatedSprite2D.offset = leftPos
		att.position = $LeftMarker.position
	else:
		att.position = $RightMarker.position
		$AnimatedSprite2D.offset = rightPos
	add_child(att)

func recoil() -> void:
	_recoiling = true
	$RecoilTimer.start()
	print("Timer start")


func _on_recoil_timer_timeout() -> void:
	print("timer end")
	_recoiling = false

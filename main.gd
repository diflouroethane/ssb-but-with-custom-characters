extends Node2D

@export var character_base: PackedScene 
var loader = C_Loader.new()
var chars: PackedStringArray = loader.load_all()
var current: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spawn_pressed() -> void:
	var a: Player = character_base.instantiate()
	add_child(a)
	a.set_props(chars[current])
	


func _on_next_pressed() -> void:
	current += 1


func _on_prev_pressed() -> void:
	current -= 1

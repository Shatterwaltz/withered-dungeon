extends CharacterBody2D
class_name Player

var network_data: NetPlayer
var speed: float = 500
var local_id: int
var is_puppet: bool

func _ready():
	local_id = multiplayer.get_unique_id()
	is_puppet = network_data.id != local_id

func _physics_process(_delta):
	if !is_puppet:
		var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
		move_and_slide()
		ToServerRpcs.update_position(position)

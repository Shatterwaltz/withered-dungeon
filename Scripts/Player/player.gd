extends CharacterBody2D
class_name Player

var network_data: NetPlayer
var is_puppet: bool

var speed: float = 500

var weapon: Weapon

func _ready():
	is_puppet = network_data.id != multiplayer.get_unique_id()
	var bow: Bow = Bow.new()
	bow.is_puppet = is_puppet
	weapon = bow
	add_child(bow)

func _physics_process(_delta):
	if !is_puppet:
		var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
		move_and_slide()
		ToServerRpcs.update_position.rpc_id(1, position)

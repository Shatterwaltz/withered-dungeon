extends CharacterBody2D
class_name Player

var network_data: NetPlayer
var is_puppet: bool

var speed: float = 500
var weapon: Weapon

@export var camera: Camera2D

func _ready():
	is_puppet = network_data.id != multiplayer.get_unique_id()
	if !is_puppet:
		equip_weapon(Constants.WEAPONS.BOW)
		camera.enabled = true

func _physics_process(_delta):
	if !is_puppet:
		var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
		move_and_slide()
		ToServerRpcs.update_position.rpc_id(1, position, get_global_mouse_position())

func update_player(p_position: Vector2, target: Vector2):
	if is_puppet:
		if weapon:
			weapon.look_at(target)
		position = p_position

func equip_weapon(weapon_name: Constants.WEAPONS):
	if !is_puppet:
		ToServerRpcs.swap_weapon.rpc_id(1, weapon_name)
	var new_weapon: Weapon = load(Constants.weapon_map[weapon_name]).instantiate() as Weapon
	new_weapon.is_puppet = is_puppet
	if weapon:
		weapon.queue_free()
	weapon = new_weapon
	add_child(weapon)

func _input(_event):
	if Input.is_action_just_pressed("equip_1") && !is_puppet:
		equip_weapon(Constants.WEAPONS.SWORD)

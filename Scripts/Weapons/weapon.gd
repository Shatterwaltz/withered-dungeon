@abstract
extends Node2D
class_name Weapon

var is_puppet: bool = false

@export var shot_cd: float = 0.75
var shot_timer: float = 0

@abstract
func fire(target: Vector2)

func _input(_event):
	if Input.is_action_just_pressed("fire_weapon") && shot_timer <= 0 && !is_puppet:
		shot_timer = shot_cd
		var target: Vector2 = get_global_mouse_position()
		fire(target)
		ToServerRpcs.fire_weapon.rpc_id(1, target)

func _physics_process(delta):
	if shot_timer > 0:
		shot_timer -= delta

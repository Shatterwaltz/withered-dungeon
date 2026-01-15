extends Node
class_name MovementComponent

var parent_enemy: Enemy

func _ready():
	var parent: Node = get_parent()
	assert(parent is Enemy, "%s not attached to an enemy" % self.name)
	parent_enemy = parent as Enemy

func get_movement(target: Player) -> Vector2:
	var movement: Vector2 = Vector2.ZERO
	if target:
		movement = (target.global_position - parent_enemy.global_position) * parent_enemy.movespeed
	return movement

extends Weapon
class_name Bow

const ARROW: PackedScene = preload("uid://br0p2feb7uqby")

func fire(target: Vector2):
	var arrow: Arrow = ARROW.instantiate() as Arrow
	arrow.is_puppet = is_puppet
	arrow.target = target
	arrow.position = get_parent().position
	get_tree().root.add_child(arrow)

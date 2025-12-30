extends Weapon

const ARROW: PackedScene = preload("uid://br0p2feb7uqby")

func fire(target: Vector2):
	var arrow: Arrow = ARROW.instantiate() as Arrow
	arrow.is_puppet = is_puppet
	arrow.target = target
	arrow.position = get_parent().position
	arrow.damage = 10
	get_tree().root.add_child(arrow)

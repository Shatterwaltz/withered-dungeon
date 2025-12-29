extends Weapon

const SLASH: PackedScene = preload("uid://4kelrwbfm1c6")

func fire(target: Vector2):
	var slash: Slash = SLASH.instantiate() as Slash
	slash.is_puppet = is_puppet
	slash.target = target
	slash.position = get_parent().position
	get_tree().root.add_child(slash)

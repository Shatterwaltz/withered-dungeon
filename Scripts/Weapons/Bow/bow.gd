extends Weapon
class_name Bow

func fire(target: Vector2):
	print("%s-%s-%s" % [target, get_parent().network_data.id, multiplayer.get_unique_id()])

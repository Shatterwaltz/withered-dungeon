class_name Constants

enum WEAPONS {
	BOW
}

static var weapon_map: Dictionary[WEAPONS, PackedScene] = {
	WEAPONS.BOW: preload("uid://cc6efc5h88mi8")
}

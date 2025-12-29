class_name Constants

enum WEAPONS {
	BOW,
	SWORD
}

static var weapon_map: Dictionary[WEAPONS, PackedScene] = {
	WEAPONS.BOW: preload("uid://cc6efc5h88mi8"),
	WEAPONS.SWORD: preload("uid://4e31saikmsdk")
}

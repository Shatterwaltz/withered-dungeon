class_name Constants

const BIG_INT: int = 999999999

enum WEAPONS {
	BOW,
	SWORD
}

static var weapon_map: Dictionary[WEAPONS, String] = {
	WEAPONS.BOW: "uid://d38inb5tt1ykl",
	WEAPONS.SWORD: "uid://4e31saikmsdk"
}

enum ENEMIES {
	GOBLIN
}

static var enemy_map: Dictionary[ENEMIES, String] = {
	ENEMIES.GOBLIN: "uid://22rvn5syg5ku"
}

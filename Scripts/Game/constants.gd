class_name Constants

const BIG_INT: int = 999999999

enum WEAPONS {
	BOW,
	SWORD
}

static var weapon_map: Dictionary[WEAPONS, PackedScene] = {
	WEAPONS.BOW: preload("uid://cc6efc5h88mi8"),
	WEAPONS.SWORD: preload("uid://4e31saikmsdk")
}

enum ENEMIES {
	GOBLIN
}

static var enemy_map: Dictionary[ENEMIES, EnemyData] = {
	ENEMIES.GOBLIN: preload("uid://22rvn5syg5ku")
}

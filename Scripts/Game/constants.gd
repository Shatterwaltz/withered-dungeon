class_name Constants

const BIG_INT: int = 999999999
const TILE_SIZE: int = 128

enum WEAPONS {
	BOW,
	SWORD
}

static var weapon_map: Dictionary[WEAPONS, String] = {
	WEAPONS.BOW: "uid://d38inb5tt1ykl",
	WEAPONS.SWORD: "uid://4e31saikmsdk"
}

enum ENEMIES {
	GOBLIN,
	BINGOL
}

static var enemy_map: Dictionary[ENEMIES, String] = {
	ENEMIES.GOBLIN: "uid://22rvn5syg5ku",
	ENEMIES.BINGOL: "uid://b4jey0jh1kdwn"
}

enum LEVELS {
	DEBUG_LEVEL,
	HERE_BE_BINGOLS
}

static var level_map: Dictionary[LEVELS, String] = {
	LEVELS.DEBUG_LEVEL: "uid://b44cymtw8l0qw",
	LEVELS.HERE_BE_BINGOLS: "uid://cguvetcp5s7sb"
}

static var default_layouts: Array[String] = [
	"uid://dbm0qqk021s52",
	"uid://md3e2et8l55h"
]

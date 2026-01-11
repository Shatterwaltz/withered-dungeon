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
	GOBLIN
}

static var enemy_map: Dictionary[ENEMIES, String] = {
	ENEMIES.GOBLIN: "uid://22rvn5syg5ku"
}

enum LEVELS {
	DEBUG_LEVEL
}

static var level_map: Dictionary[LEVELS, String] = {
	LEVELS.DEBUG_LEVEL: "uid://b44cymtw8l0qw"
}

enum LAYOUTS {
	DEBUG_DUNGEON,
	LAYOUT_2
}

static var layout_map: Dictionary[LAYOUTS, String] = {
	LAYOUTS.DEBUG_DUNGEON: "uid://dbm0qqk021s52",
	LAYOUTS.LAYOUT_2: "uid://md3e2et8l55h"
}

static var default_layouts: Array[String] = ["uid://dbm0qqk021s52", "uid://md3e2et8l55h"]

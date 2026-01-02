extends Node
class_name Level

var layout: Layout

# factory function
static func from_data(level_data: LevelData) -> Level:
	var level: Level = Level.new()
	level.layout = load(Constants.layout_map[level_data.layout_pool.pick_random()]).instantiate()
	level.layout.target_enemy_count = randi_range(level_data.min_enemies, level_data.max_enemies)
	return level

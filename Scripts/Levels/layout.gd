extends Node2D
class_name Layout

@export var enemy_spawn_parent: Node2D
@export var player_spawn: Node2D
var id: int = 0
var target_enemy_count: int = 1
var next_level: Constants.LEVELS
var remaining_enemies: int = 0

# factory function
static func from_data(level_data: LevelData) -> Layout:
	# clients should only need the selected layout to load, enemies will be synced naturally
	var selected_layout: Constants.LAYOUTS = level_data.layout_pool.pick_random()
	var layout: Layout = load(Constants.layout_map[selected_layout]).instantiate()
	layout.target_enemy_count = randi_range(level_data.min_enemies, level_data.max_enemies)
	layout.next_level = level_data.next_level
	layout.id = Utils.generate_id()
	return layout

func _ready() -> void:
	if Network.is_server:
		assert(enemy_spawn_parent != null, "%s has no enemy spawn parent" % self.name)
		assert(player_spawn != null, "%s has no player spawn" % self.name)
		var enemy_spawns: Array[Node] = enemy_spawn_parent.get_children()
		if Gamestate.players.size() == 0:
			for player_id in Network.players.keys():
				ToClientRpcs.spawn_player.rpc(player_id, player_spawn.position)
		for i in range(target_enemy_count):
			if enemy_spawns.size() < 1:
				break
			var spawn_point_index: int = randi_range(0, enemy_spawns.size() - 1)
			# TODO: randomize the enemy choice here
			var enemy_id: int = Utils.generate_id()
			ToClientRpcs.spawn_enemy.rpc(enemy_id, Constants.ENEMIES.GOBLIN, enemy_spawns[spawn_point_index].position)
			enemy_spawns.remove_at(spawn_point_index)
			remaining_enemies += 1
			Gamestate.enemies[enemy_id].enemy_died.connect(_on_enemy_death)

func activate_room():
	# TODO: This should uncover room, make enemies start acting, and load next level scene
	pass

func _on_enemy_death(_id: int):
	#remaining_enemies -= 1
	#print(remaining_enemies)
	#if remaining_enemies <= 0:
		#queue_free()
	pass

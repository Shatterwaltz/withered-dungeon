extends Node2D
class_name Layout

@export var enemy_spawn_parent: Node2D
@export var player_spawn: Node2D
@export var tilemap: TileMapLayer
@export var exit_box: Area2D
var id: int = 0
var target_enemy_count: int = 1
var next_level: Constants.LEVELS
var remaining_enemies: int = 0
var enemy_pool: Array[Constants.ENEMIES] = []
var next_layout_id: int = -1
var players_exited: int = 0

# factory function
static func from_data(level_data: LevelData, layout_index: int, layout_id: int) -> Layout:
	# clients should only need the selected layout to load, enemies will be synced naturally
	var selected_layout_uid: String = Constants.default_layouts[layout_index]
	var layout: Layout = load(selected_layout_uid).instantiate()
	layout.target_enemy_count = randi_range(level_data.min_enemies, level_data.max_enemies)
	layout.next_level = level_data.next_level
	layout.id = layout_id
	layout.visible = false
	layout.enemy_pool = level_data.enemy_pool
	return layout

func _ready() -> void:
	exit_box.body_entered.connect(_on_exit_overlap)
	if Network.is_server:
		assert(enemy_spawn_parent != null, "%s has no enemy spawn parent" % self.name)
		assert(player_spawn != null, "%s has no player spawn" % self.name)
		assert(tilemap != null, "%s has no tilemap layer" % self.name)
		assert(exit_box != null, "%s has no exit box" % self.name)
		var enemy_spawns: Array[Node] = enemy_spawn_parent.get_children()
		print(name)
		if Gamestate.players.size() == 0:
			print('spawning players on %s' % id)
			for player_id in Network.players.keys():
				ToClientRpcs.spawn_player.rpc(player_id, player_spawn.global_position)
		for i in range(target_enemy_count):
			if enemy_spawns.size() < 1:
				break
			var spawn_point_index: int = randi_range(0, enemy_spawns.size() - 1)
			var enemy_id: int = Utils.generate_id()
			ToClientRpcs.spawn_enemy.rpc(enemy_id, enemy_pool.pick_random(), enemy_spawns[spawn_point_index].position, id)
			enemy_spawns.remove_at(spawn_point_index)

func add_enemy(enemy: Enemy):
	remaining_enemies += 1
	enemy.enemy_died.connect(_on_enemy_death)
	add_child(enemy)

func activate_room():
	visible = true
	if Network.is_server:
		var next_id: int = Utils.generate_id()
		ToClientRpcs.set_layout_connection.rpc(id, next_id)
		ToClientRpcs.load_level.rpc(next_level, randi_range(0, Constants.default_layouts.size() - 1), next_layout_id)
	#TODO: set up active/inactive enemy states

func _on_enemy_death(_id: int):
	remaining_enemies -= 1
	if remaining_enemies <= 0:
		exit_box.visible = true
		if Network.is_server:
			ToClientRpcs.activate_layout.rpc(next_layout_id)

func _on_exit_overlap(body):
	if body is Player && remaining_enemies <= 0:
		body.position = Gamestate.loaded_layouts[next_layout_id].player_spawn.global_position
		players_exited += 1
		if players_exited >= Gamestate.players.size():
			queue_free()

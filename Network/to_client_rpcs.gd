extends Node
const PLAYER = preload("uid://bicgmnxc0j4bc")

@rpc("authority", "call_local", "reliable")
func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/debug_area.tscn")

@rpc("authority", "call_local", "reliable")
func unload_scene() -> void:
	get_tree().unload_current_scene()

@rpc("authority", "call_local", "reliable")
func load_level(level: Constants.LEVELS, layout_index: int, layout_id: int) -> void:
	var level_data: LevelData = load(Constants.level_map[level]) as LevelData
	var layout: Layout = Layout.from_data(level_data, layout_index, layout_id)
	layout.position.y += Gamestate.level_load_offset
	Gamestate.level_load_offset += layout.tilemap.get_used_rect().size.y * Constants.TILE_SIZE
	Gamestate.loaded_layouts[layout.id] = layout
	Gamestate.add_child(layout)

@rpc("authority", "call_local", "reliable")
func activate_layout(layout_id: int):
	Gamestate.loaded_layouts[layout_id].activate_room()

##connect layout with initial_id to layout with subsequent_id
@rpc("authority", "call_local", "reliable")
func set_layout_connection(initial_id: int, subsequent_id: int):
	Gamestate.loaded_layouts[initial_id].next_layout_id = subsequent_id

@rpc("authority", "call_remote", "reliable")
func set_seed(seed_val: int):
	Gamestate.seed_val = seed_val
	seed(seed_val)

@rpc("authority", "call_local", "reliable")
func spawn_player(id: int, position: Vector2) -> void:
	var player: Player = PLAYER.instantiate() as Player
	var net_data = NetPlayer.new()
	net_data.id = id
	player.network_data = net_data
	player.position = position
	Gamestate.players[id] = player
	Gamestate.add_child(player)

@rpc("authority", "call_local", "unreliable_ordered")
func update_player(player_id: int, position: Vector2, target: Vector2) -> void:
	if !Gamestate.players.has(player_id):
		return
	var player: Player = Gamestate.players[player_id]
	player.update_player(position, target)

@rpc("authority", "call_local", "unreliable")
func fire_weapon(player_id: int, target: Vector2):
	var player: Player = Gamestate.players[player_id]
	if player.is_puppet:
		player.weapon.fire(target)

@rpc("authority", "call_local", "reliable")
func swap_weapon(player_id: int, new_weapon: Constants.WEAPONS):
	var player: Player
	if !Gamestate.players.has(player_id):
		return
	else:
		player = Gamestate.players[player_id]
		if player.is_puppet:
			player.equip_weapon(new_weapon)

@rpc("authority", "call_local", "reliable")
func spawn_enemy(id: int, enemy_type: Constants.ENEMIES, position: Vector2, layout_id: int):
	var enemy: Enemy = Enemy.from_data(load(Constants.enemy_map[enemy_type]), id)
	enemy.position = position
	Gamestate.loaded_layouts[layout_id].add_enemy(enemy)

@rpc("authority", "call_local", "reliable")
func update_enemy_target(enemy_id: int, target_id: int):
	var enemy: Enemy = Gamestate.enemies.get(enemy_id)
	if enemy:
		enemy.target = Gamestate.players.get(target_id)

@rpc("authority", "call_local", "reliable")
func trigger_enemy_attack(id: int, target_id: int):
	if Gamestate.enemies.has(id):
		Gamestate.enemies[id].trigger_attack(Gamestate.players[target_id])

@rpc("authority", "call_local", "reliable")
func trigger_enemy_death(id: int):
	if Gamestate.enemies.has(id):
		Gamestate.enemies[id].die()

@rpc("authority", "call_local", "reliable")
func damage_enemy(id: int, damage: int, attacker_id: int):
	if Gamestate.enemies.has(id):
		Gamestate.enemies[id].take_damage(damage, attacker_id)

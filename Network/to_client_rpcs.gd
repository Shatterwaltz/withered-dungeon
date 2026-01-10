extends Node
const PLAYER = preload("uid://bicgmnxc0j4bc")

@rpc("authority", "call_local", "reliable")
func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/debug_area.tscn")

@rpc("authority", "call_local", "reliable")
func unload_scene() -> void:
	get_tree().unload_current_scene()

@rpc("authority", "call_local", "reliable")
func load_level(level: Constants.LEVELS) -> void:
	var level_data: LevelData = load(Constants.level_map[level]) as LevelData
	var layout: Layout = Layout.from_data(level_data)
	Gamestate.add_child(layout)

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

@rpc("authority", "call_local", "reliable")
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
func spawn_enemy(id: int, enemy_type: Constants.ENEMIES, position: Vector2):
	var enemy: Enemy = Enemy.from_data(load(Constants.enemy_map[enemy_type]), id)
	enemy.position = position
	get_tree().root.add_child(enemy)

@rpc("authority", "call_local", "reliable")
func trigger_enemy_attack(id: int, target_id: int):
	if Gamestate.enemies.has(id):
		Gamestate.enemies[id].trigger_attack(Gamestate.players[target_id])

@rpc("authority", "call_local", "reliable")
func trigger_enemy_death(id: int):
	if Gamestate.enemies.has(id):
		Gamestate.enemies[id].die()

@rpc("authority", "call_local", "reliable")
func damage_enemy(id: int, damage: int):
	if Gamestate.enemies.has(id):
		Gamestate.enemies[id].take_damage(damage)

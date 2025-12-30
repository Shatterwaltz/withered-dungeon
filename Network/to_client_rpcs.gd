extends Node
const PLAYER = preload("uid://bicgmnxc0j4bc")

@rpc("authority", "call_local", "reliable")
func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/debug_area.tscn")

@rpc("authority", "call_remote", "reliable")
func set_seed(seed_val: int):
	Gamestate.seed_val = seed_val
	seed(seed_val)

@rpc("authority", "call_local", "reliable")
func spawn_player(id: int) -> void:
	var player: Player = PLAYER.instantiate() as Player
	var net_data = NetPlayer.new()
	net_data.id = id
	player.network_data = net_data
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
func spawn_enemy(id: int, enemy_type: Constants.ENEMIES):
	var enemy: Enemy = Enemy.from_data(load(Constants.enemy_map[enemy_type]), id)
	enemy.position = Vector2(200, 200)
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

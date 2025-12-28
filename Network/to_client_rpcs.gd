extends Node
const PLAYER = preload("uid://bicgmnxc0j4bc")

@rpc("authority", "call_local", "reliable")
func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/debug_area.tscn")

@rpc("authority", "call_local", "reliable")
func spawn_player(id: int) -> void:
	var player: Player = PLAYER.instantiate() as Player
	var net_data = NetPlayer.new()
	net_data.id = id
	player.network_data = net_data
	Gamestate.players[id] = player
	Gamestate.add_child(player)

@rpc("authority", "call_local", "unreliable_ordered")
func update_player(id: int, position: Vector2, target: Vector2) -> void:
	if !Gamestate.players.has(id):
		return
	var player: Player = Gamestate.players[id]
	if player.is_puppet:
		player.position = position
		player.weapon.look_at(target)

@rpc("authority", "call_local", "reliable")
func fire_weapon(player_id: int, target: Vector2):
	var player: Player = Gamestate.players[player_id]
	if player.is_puppet:
		player.weapon.fire(target)

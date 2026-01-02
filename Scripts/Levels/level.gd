extends Node
class_name Level

@export var enemy_pool: Array[Constants.ENEMIES] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Network.is_server:
		for player_id in Network.players.keys():
			ToClientRpcs.spawn_player.rpc(player_id)
		ToClientRpcs.spawn_enemy.rpc(Utils.generate_id(), Constants.ENEMIES.GOBLIN)

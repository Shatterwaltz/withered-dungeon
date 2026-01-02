extends Node2D
class_name Layout

@export var enemy_spawn_parent: Node2D
@export var player_spawn: Node2D
var target_enemy_count: int = 1

func _ready() -> void:
	if Network.is_server:
		assert(enemy_spawn_parent != null, "%s has no enemy spawn parent" % self.name)
		assert(player_spawn != null, "%s has no player spawn" % self.name)
		var enemy_spawns: Array[Node2D] = enemy_spawn_parent.get_children() as Array[Node2D]
		if Gamestate.players.size() == 0:
			for player_id in Network.players.keys():
				ToClientRpcs.spawn_player.rpc(player_id, player_spawn.position)
		for i in range(target_enemy_count):
			if enemy_spawns.size() < 1:
				break
			var spawn_point_index: int = randi_range(0, enemy_spawns.size() - 1)
			ToClientRpcs.spawn_enemy.rpc(Utils.generate_id(), Constants.ENEMIES.GOBLIN, enemy_spawns[spawn_point_index].position)
			enemy_spawns.remove_at(spawn_point_index)

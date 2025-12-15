extends Node

@rpc("any_peer", "reliable")
func toggle_ready() -> void:
	if !Network.is_server:
		return
	Network.toggle_ready(multiplayer.get_remote_sender_id())

@rpc("any_peer", "unreliable_ordered")
func update_position(position: Vector2) -> void:
	ToClientRpcs.update_player.rpc(multiplayer.get_remote_sender_id(), position)

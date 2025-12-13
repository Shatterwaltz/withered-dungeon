extends Node

@rpc("any_peer", "reliable")
func toggle_ready() -> void:
	if !Network.is_server:
		return
	Network.toggle_ready(multiplayer.get_remote_sender_id())

extends Node

## Main network script, autload on both client and server.
## Contains some needed RPCs

const PORT: int = 25565
const MAX_CLIENTS: int = 32

var is_server: bool = false
var peer: ENetMultiplayerPeer
## ids mapped to player info
var players: Dictionary[int, NetPlayer] = {}

func _ready() -> void:
	is_server = OS.has_feature("dedicated_server")
	var creation_error: Error
	if is_server:
		# Create server.
		peer = ENetMultiplayerPeer.new()
		creation_error = peer.create_server(PORT, MAX_CLIENTS)
		multiplayer.multiplayer_peer = peer
		if creation_error != OK:
			printerr("Server- creation failed")
		else:
			print("Server- created successfully")
		peer.peer_connected.connect(_on_player_connect)
		peer.peer_disconnected.connect(_on_player_disconnect)

func create_client(ip: String) -> Error:
	peer = ENetMultiplayerPeer.new()
	var creation_error: Error = peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	if creation_error != OK:
		printerr("Client %d- creation failed" % multiplayer.get_unique_id())
	else:
		print("Client %d- created successfully" % multiplayer.get_unique_id())
	return creation_error

func _on_player_connect(id: int) -> void:
	print("Server- Player connected, id: %d" % id)
	var netplayer: NetPlayer = NetPlayer.new()
	netplayer.id = id
	players[id] = netplayer
	print("Server- %s" % [players])

func _on_player_disconnect(id: int) -> void:
	print("Server- Player disconnected, id: %d" % id)
	if players.has(id):
		players.erase(id)
	print("Server- %s" % [players])

func toggle_ready(player_id: int) -> void:
	if !is_server:
		return
	if players.has(player_id):
		players[player_id].is_ready = !players[player_id].is_ready
	if players.size() < 2:
		return
	var all_ready: bool = true
	for player in players.values():
		if !player.is_ready:
			all_ready = false
			print("Server- Player %d is not ready" % player.id)
	print("Server- All players are ready? %s" % all_ready)
	if all_ready:
		start_game()

func start_game():
	## Game start logic
	pass

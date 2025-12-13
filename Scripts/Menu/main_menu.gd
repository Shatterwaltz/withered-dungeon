extends Control

@export var connect_button: Button
@export var ready_button: Button
@onready var ip_input: LineEdit = $IpInput
var is_ready: bool = false

func _ready() -> void:
	assert(connect_button != null, "Connect button not supplied in menu scene")
	connect_button.pressed.connect(_on_connect_pressed)
	assert(ready_button != null, "Ready button not supplied in menu scene")
	ready_button.pressed.connect(_on_ready_pressed)

func _on_connect_pressed() -> void:
	multiplayer.connected_to_server.connect(_on_connected)
	Network.create_client(ip_input.text)

func _on_ready_pressed() -> void:
	ToServerRpcs.toggle_ready.rpc_id(1)
	is_ready = !is_ready
	if is_ready:
		ready_button.text = "Unready"
	else:
		ready_button.text = "Ready"

func _on_connected() -> void:
	connect_button.hide()
	ready_button.show()

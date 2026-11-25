extends Control

@onready var status: Label = $VBox/Status
@onready var host_input: LineEdit = $VBox/Host
@onready var connect_button: Button = $VBox/Connect

func _ready() -> void:
	status.text = "Not connected"
	host_input.text = Net.get_default_host()
	connect_button.pressed.connect(_on_connect_pressed)
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(func(): status.text = "Connection failed")
	multiplayer.server_disconnected.connect(func(): status.text = "Disconnected from server")

func _on_connect_pressed() -> void:
	status.text = "Connecting..."
	Net.start_client(host_input.text)


func _on_connected() -> void:
	status.text = "Connected!"
	$VBox.hide()

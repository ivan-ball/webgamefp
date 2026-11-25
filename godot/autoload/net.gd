extends Node

const PORT := 9080

func start_server() -> void:
	var peer := WebSocketMultiplayerPeer.new()
	var err := peer.create_server(PORT)
	if err != OK:
		push_error("Could not start server: %s" % error_string(err))
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(func(id): print("Peer connected: ", id))
	multiplayer.peer_disconnected.connect(func(id): print("Peer disconnected: ", id))
	print("Server listening on port ", PORT)

func start_client(host: String) -> void:
	var peer := WebSocketMultiplayerPeer.new()
	var err := peer.create_client("ws://%s:%d" % [host, PORT])
	if err != OK:
		push_error("Could not connect: %s" % error_string(err))
		return
	multiplayer.multiplayer_peer = peer

func get_default_host() -> String:
	if OS.has_feature("web"):
		return str(JavaScriptBridge.eval("window.location.hostname"))
	return "127.0.0.1"

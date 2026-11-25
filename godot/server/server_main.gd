extends Node

@onready var players: Node2D = $World/Players

func _ready() -> void:
	print("Starting dedicated server...")
	Net.start_server()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int) -> void:
	var p := preload("res://game/player.tscn").instantiate()
	p.name = str(id)
	p.position = Vector2(200 + randi() % 300, 200)
	players.add_child(p)

func _on_peer_disconnected(id: int) -> void:
	var p := players.get_node_or_null(str(id))
	if p:
		p.queue_free()

extends Node

func _ready() -> void:
	print("Starting dedicated server...")
	Net.start_server()

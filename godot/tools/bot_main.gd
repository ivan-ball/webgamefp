extends Node

func _ready() -> void:
	Net.start_client("127.0.0.1")

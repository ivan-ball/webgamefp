extends Node

func _ready() -> void:
	var args := OS.get_cmdline_args() + OS.get_cmdline_user_args()
	var scene := "res://client/client_main.tscn"
	if "--bot" in args:
		scene = "res://tools/bot_main.tscn"
	elif OS.has_feature("dedicated_server") or "--server" in args or DisplayServer.get_name() == "headless":
		scene = "res://server/server_main.tscn"
	get_tree().change_scene_to_file.call_deferred(scene)

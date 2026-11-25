extends CharacterBody2D

const SPEED := 220.0
var input_dir := Vector2.ZERO  # only used on the server

func _ready() -> void:
	$ColorRect.color = Color.from_hsv(float(name.to_int() % 360) / 360.0, 0.8, 1.0)

func _physics_process(_delta: float) -> void:
	if multiplayer.is_server():
		velocity = input_dir * SPEED
		move_and_slide()
	elif name.to_int() == multiplayer.get_unique_id():
		var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		send_input.rpc_id(1, dir)

@rpc("any_peer", "call_remote", "unreliable_ordered")
func send_input(dir: Vector2) -> void:
	if not multiplayer.is_server():
		return
	# Only accept input from the peer that owns this player
	if multiplayer.get_remote_sender_id() != name.to_int():
		return
	input_dir = dir.limit_length(1.0)

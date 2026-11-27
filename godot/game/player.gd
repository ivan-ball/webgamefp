extends CharacterBody2D

const SPEED := 220.0

var input_dir := Vector2.ZERO               # server only
@export var facing := Vector2.DOWN          # replicated to every client

@onready var sword_pivot: Node2D = $SwordPivot
const ATTACK_COOLDOWN := 0.5
const SWING_TIME := 0.2
var can_attack := true                      # server only
@onready var swing: Node2D = $SwordPivot/Swing

func _ready() -> void:
	$ColorRect.color = Color.from_hsv(float(name.to_int() % 360) / 360.0, 0.8, 1.0)
	sword_pivot.hide()

func _physics_process(_delta: float) -> void:
	if multiplayer.is_server():
		velocity = input_dir * SPEED
		move_and_slide()
		if input_dir != Vector2.ZERO:
			facing = input_dir.normalized()
	elif name.to_int() == multiplayer.get_unique_id():
		var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		send_input.rpc_id(1, dir)
		if Input.is_action_just_pressed("attack"):
			request_attack.rpc_id(1)
	sword_pivot.rotation = facing.angle()   # everyone: sword follows `facing`

@rpc("any_peer", "call_remote", "unreliable_ordered")
func send_input(dir: Vector2) -> void:
	if not multiplayer.is_server():
		return
	if multiplayer.get_remote_sender_id() != name.to_int():
		return
	input_dir = dir.limit_length(1.0)




@rpc("any_peer", "call_remote", "reliable")
func request_attack() -> void:
	if not multiplayer.is_server():
		return
	if multiplayer.get_remote_sender_id() != name.to_int():
		return
	if not can_attack:
		return
	can_attack = false
	play_swing.rpc()                        # tell everyone to show the swing
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true

@rpc("authority", "call_local", "reliable")
func play_swing() -> void:
	sword_pivot.show()
	swing.rotation_degrees = -60.0
	var tween := create_tween()
	tween.tween_property(swing, "rotation_degrees", 60.0, SWING_TIME)
	tween.tween_callback(sword_pivot.hide)

extends Area2D

@export var GAME_STATE_PARAM = ""
@export var move_distance = 10.0  # Distance to move up and down
@export var move_time = 1.0  # Time to move up or down

signal item_picked

var tween:Tween
var label

var player_entered: bool = false

func _ready():
	tween = get_tree().create_tween().set_loops()
	label = find_child("Label")
	display_label(false)
	body_entered.connect(func(body): detect_player(body, "ENTERED"))
	body_exited.connect(func(body): detect_player(body, "EXITED"))

func _input(_event):
	if Input.is_action_pressed("pick_up") and player_entered:
		picked_up()

func picked_up():
	if GAME_STATE_PARAM in Game.state:
		Game.state[GAME_STATE_PARAM] = true
		item_picked.emit()
		queue_free()

func detect_player(body: Node2D, status):
	if status == "ENTERED" and body and body.is_in_group("player"):
		player_entered = true
		display_label(true)
	if status == "EXITED" and body and body.is_in_group("player"):
		player_entered = false
		display_label(false)

func display_label(status:bool):
	if label:
		label.visible = status


extends Area2D

@export var conversation_path:String

@onready var speed_label : Label = $CanvasLayer.find_child("Speech")

var player_entered:bool = false

var latest_index = 0
var conversation

# Called when the node enters the scene tree for the first time.
func _ready():
	latest_index = 0
	conversation = Game.load_conversation(conversation_path)
	speed_label.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(_event):
	if len(conversation) == 0:
		return
	if Input.is_action_just_pressed("pick_up") and player_entered:
		var conv = conversation[min(latest_index, len(conversation) - 1)] 
		speed_label.text = conv['speaker'] + ": " + conv['dialog']
		if conv['action'] == 'check_state':
			if Game.state[conv['state']] == conv['value']:
				latest_index += 1
		elif conv['action'] == 'conversation' and latest_index < len(conversation):
			latest_index += 1
		elif conv['action'] == 'give_battery':
			Game.state['HAS_BATTERY'] += 1
			Game.state[conv['take']] = "DONE"
			latest_index += 1
		elif conv['action'] == "real_game_end":
			Game.state['GAME_END'] = true
		speed_label.show()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_entered = true

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_entered = false
		speed_label.hide()


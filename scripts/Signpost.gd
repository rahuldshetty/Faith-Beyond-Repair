extends Area2D

@export var message:String

@onready var speech_label : Label = $CanvasLayer.find_child("Speech")

var player_entered:bool = false

var latest_index = 0
var conversation

# Called when the node enters the scene tree for the first time.
func _ready():
	speech_label.text = message
	speech_label.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(_event):
	if Input.is_action_just_pressed("pick_up") and player_entered:
		speech_label.show()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_entered = true

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_entered = false
		speech_label.hide()


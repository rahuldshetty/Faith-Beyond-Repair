extends Area2D

@onready var label:Label = $CanvasLayer/Speech

const FAIL_MESSAGES = [
	"Me: Not here!",
	"Me: Oh Shoot! The ghots took away the GI Joe. Why do I feel like I'm back in highschool?",
	"Me: I came here to fix the lights, not play monkey!!",
	"Me: No wonder the poor Boy 1 was crying. These ghosts must be dead bullies.",
	"Me: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
]
const SUCCESS_MESSAGE = "Me: Finally! I did it. Now I should get back to Boy 1"

var player = null

func _ready():
	label.hide()

func _input(_event):
	if Game.state['HAS_GIJOE'] or (typeof(Game.state['HAS_GIJOE']) == TYPE_STRING and Game.state['HAS_GIJOE'] == "DONE"):
		return
	if Input.is_action_just_pressed("pick_up") and player != null:
		# Not found!
		randomize()
		if randf() < 0.8:
			label.text = FAIL_MESSAGES.pick_random()
			label.show()
			return
		if player.flashlight_status == player.FLASHLIGHT_STATUS.ON:
			label.text = SUCCESS_MESSAGE
			label.show()
			Game.state['HAS_GIJOE'] = true
			player.gi_joe.show()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		$Label.show()


func _on_body_exited(body):
	if body.is_in_group("player"):
		player = null
		label.hide()
		$Label.hide()

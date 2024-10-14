extends Area2D

@onready var speech_label = $CanvasLayer/Speech

var player = null


func _ready():
	$FlashLight.hide()
	player = null

func _input(event):
	if Input.is_action_just_pressed("pick_up") and player != null:
		if Game.state['HAS_BATTERY'] == 0:
			speech_label.text = "The Lamp Post is dead. Need batteries!"
			speech_label.show()
			return
		else:
			speech_label.text = "The Lamp Post is fixed!"
			Game.state['LAMP_FIXED'] = true
			$FlashLight.show()
			speech_label.show()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		player = null
		speech_label.hide()

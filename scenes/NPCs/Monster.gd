extends Area2D

@onready var animation = $AnimatedSprite2D

var SPEED = 380.0
const time_to_die = 20

var direction = Vector2.ZERO
var initial_position = null

var timer

signal game_over

func _ready():
	animation.play("default")
	
	timer = Timer.new()
	timer.wait_time = time_to_die
	timer.one_shot = true
	timer.connect("timeout", _ontimeout)
	add_child(timer)
	timer.start()

func _physics_process(delta):
	position += direction * SPEED * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.flashlight_status in [
			body.FLASHLIGHT_STATUS.OFF,
			body.FLASHLIGHT_STATUS.FULL,
			body.FLASHLIGHT_STATUS.EMPTY
		]:
			game_over.emit()
		if body.flashlight_status == body.FLASHLIGHT_STATUS.ON:
			die()


func _ontimeout():
	queue_free()

func die():
	set_collision_layer_value(0, false)
	set_collision_mask_value(0, false)
	direction = Vector2.ZERO
	animation.animation_finished.connect(queue_free)
	animation.play("die")

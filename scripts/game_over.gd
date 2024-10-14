extends Node2D

@onready var animated = $CanvasLayer/AnimatedSprite2D
@onready var button = $CanvasLayer/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	animated.hide()
	button.hide()

func start():
	animated.show()
	animated.play()

func _on_animated_sprite_2d_animation_finished():
	button.show()

func _on_button_pressed():
	get_tree().reload_current_scene()

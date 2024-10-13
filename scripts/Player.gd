extends CharacterBody2D

var speed = 120  # speed in pixels/sec

@onready var sprite_animation:AnimatedSprite2D = $AnimatedSprite2D

@onready var flash_light:Light2D = $FlashLight
@onready var flash_light_label = $CanvasGroup/FlashLightKeys
@onready var flash_light_sound = $AudioListener2D/FlashlightSound
@onready var flash_light_bar = $CanvasGroup/FlashLightKeys/TextureProgressBar

enum FLASHLIGHT_STATUS {
	FULL,
	ON,
	OFF,
	EMPTY,
}
const flashlight_discharge_rate = 0.08
const flashlight_recharge_rate = 0.06
const flashlight_total_charge = 100
var flashlight_charge = 100
var flashlight_status = FLASHLIGHT_STATUS.FULL

func _ready():
	flash_light_label.hide()
	flashlight(false)

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

func _process(_delta):
	animate()
	update_flashlight_progress(_delta)

func animate():
	if velocity.length() > 0:
		sprite_animation.play("walk")
	elif velocity.length() == 0:
		sprite_animation.stop()

func _input(_event):
	if Input.is_action_just_pressed("toggle_flashlight"):
		flashlight(!flash_light.visible)

func flashlight(on):
	if Game.state["HAS_FLASHLIGHT"] and on:
		flash_light.show()
		flashlight_status = FLASHLIGHT_STATUS.ON
	if not on:
		flash_light.hide()
		flashlight_status = FLASHLIGHT_STATUS.OFF
	if Game.state["HAS_FLASHLIGHT"]:
		flash_light_sound.play()

func _on_flashlight_item_picked():
	flash_light_label.show()
	
func update_flashlight_progress(_delta):
	match flashlight_status:
		FLASHLIGHT_STATUS.ON:
			flashlight_charge -= flashlight_discharge_rate
		FLASHLIGHT_STATUS.OFF:
			flashlight_charge += flashlight_recharge_rate
	
	flashlight_charge = clampf(flashlight_charge, 0, 100)
	
	if flashlight_charge == 0 and flashlight_status == FLASHLIGHT_STATUS.ON:
		# Switch off flashlight if its off
		flashlight_status = FLASHLIGHT_STATUS.EMPTY
		flashlight(false)
	if flashlight_charge == 100:
		flashlight_status = FLASHLIGHT_STATUS.FULL
	
	flash_light_bar.value = 100*flashlight_charge/flashlight_total_charge


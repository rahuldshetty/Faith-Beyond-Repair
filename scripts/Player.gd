extends CharacterBody2D

var speed = 120  # speed in pixels/sec

@onready var sprite_animation:AnimatedSprite2D = $AnimatedSprite2D

@onready var flash_light:Light2D = $FlashLight
@onready var flash_light_label = $CanvasGroup/FlashLightKeys
@onready var flash_light_sound = $AudioListener2D/FlashlightSound
@onready var flash_light_bar = $CanvasGroup/FlashLightKeys/TextureProgressBar

@onready var gi_joe = $"CanvasGroup/GI Joe"

@onready var battery = $CanvasGroup/FlashLightKeys/Battery
@onready var battery_label = $"CanvasGroup/FlashLightKeys/Battery/Battery Label"

enum FLASHLIGHT_STATUS {
	FULL,
	ON,
	OFF,
	EMPTY,
}
const flashlight_discharge_rate = 0.13
const flashlight_recharge_rate = 0.05
const flashlight_total_charge = 100
var flashlight_charge = 100
var flashlight_status = FLASHLIGHT_STATUS.FULL

var game_over_status = false

func _ready():
	game_over_status = false
	gi_joe.hide()
	flash_light_label.hide()
	flashlight(false)

func _physics_process(_delta):
	if game_over_status:
		return
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

func _process(_delta):
	animate()
	update_flashlight_progress(_delta)
	update_gijoe_ui()
	update_battery_label()

func animate():
	if game_over_status:
		return
	if velocity.length() > 0:
		sprite_animation.play("walk")
	elif velocity.length() == 0:
		sprite_animation.stop()

func _input(_event):
	if game_over_status:
		return
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
	if game_over_status:
		return
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

func update_gijoe_ui():
	if game_over_status:
		return
	if (typeof(Game.state['HAS_GIJOE']) == TYPE_STRING and Game.state['HAS_GIJOE'] == "DONE"):
		gi_joe.hide()

func update_battery_label():
	battery_label.text =  str(Game.state['HAS_BATTERY']) + " / " + str(Game.TOTAL_BATTERY)

func game_over():
	game_over_status = true
	$CanvasGroup.hide()

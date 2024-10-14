extends Node2D

@onready var timer:Timer = $Timer
@export var player: Node2D
@export var game_over = Node2D

const monster_res1 = preload("res://scenes/NPCs/Monster.tscn")

const MIN_SPAWN_WAIT = 3
const MAX_SPAWN_WAIT = 9

func _ready():
	timer.wait_time = pick_spawn_time()


func _on_timer_timeout():
	if not Game.state['GAME_END'] and (Game.state['HAS_BATTERY'] == 0 or Game.state['SAFE_ZONE']):
		return
	spawn()

func end_game():
	timer.stop()
	if game_over:
		game_over.start()
	if player:
		player.game_over()

func spawn():
	if player and monster_res1:
		var monster = monster_res1.instantiate()
		randomize()
		var pos = pick_pos()
		monster.initial_position = pos
		monster.position = player.position + pos
		monster.direction = monster.position.direction_to(player.position)
		monster.game_over.connect(end_game)

		add_child(monster)
		timer.wait_time = pick_spawn_time()
		if Game.state['GAME_END']:
			timer.wait_time = 0.1
			monster.SPEED = 180.0
		print("SPAWNED MONSTER")

func pick_spawn_time():
	randomize()
	return randi_range(MIN_SPAWN_WAIT, MAX_SPAWN_WAIT)
	
func pick_pos():
	randomize()
	var SCREEN_SIZE = get_viewport().size 
	var radius = SCREEN_SIZE.x * sqrt(2)
	var x = randf_range(0, radius)
	var y = sqrt(radius*radius - x*x)
	return Vector2(x, y)

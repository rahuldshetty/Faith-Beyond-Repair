extends PointLight2D

var tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = get_tree().create_tween().set_loops()
	animate_flicker()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func animate_flicker():
	tween.tween_property(self, "energy", 5, 2).from_current()

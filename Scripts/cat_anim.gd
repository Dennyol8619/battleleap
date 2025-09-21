extends AnimatedSprite2D

@onready var timer:Timer = $Timer
var rnd:int

# Called when the node enters the scene tree for the first time.
func _ready():
	rnd = randi_range(1, 20)
	timer.start(rnd)

func _on_timer_timeout():
	timer.stop()
	rnd = randi_range(0, 4)
	match rnd:
		0: play("Licking")
		1: play("Petting")
		2: play("Sitting")
		3: play("Sleeping")
		4: play("Stretching")
	rnd = randi_range(1, 20)
	timer.start(rnd)

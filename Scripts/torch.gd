extends Sprite2D

enum Colors {Red, Green, Blue, Purple, White, RandomColor}

@export var color:Colors = Colors.RandomColor
@onready var fire:AnimatedSprite2D = $Fire
@onready var time:Timer = $Timer

func _ready():
	time.start(0.1)

func _on_timer_timeout():
	time.stop()
	fire.changeColor(color)

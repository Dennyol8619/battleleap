extends Sprite2D

enum Colors {Red, Green, Blue, Purple, White, RandomColor}

@export var color:Colors = Colors.RandomColor
@onready var fire:AnimatedSprite2D = $Fire

func _ready():
	fire.changeColor(color)

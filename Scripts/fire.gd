extends AnimatedSprite2D

enum Colors {Red, Green, Blue, Purple, White, RandomColor}

@export var color:Colors = Colors.Red
@export var can_damage:bool = true
@export var is_background:bool = false
@onready var fire_collision:CollisionShape2D = $FireArea2D/FireCollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_background:
		z_index = 0
	changeColor(color)

func changeColor(fcolor):
	if fcolor == Colors.RandomColor:
		var rnd:int = randi_range(0, 4)
		match rnd:
			0: fcolor = Colors.Red
			1: fcolor = Colors.Green
			2: fcolor = Colors.Blue
			3: fcolor = Colors.Purple
			4: fcolor = Colors.White
	match fcolor:
		Colors.Red: play("Red")
		Colors.Green: play("Green")
		Colors.Blue: play("Blue")
		Colors.Purple: play("Purple")
		Colors.White: play("White")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !can_damage and !fire_collision.disabled:
		fire_collision.disabled = true

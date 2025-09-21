extends Node2D

enum Colors {Red, Green, Blue, Purple, White, RandomColor}
@export var color:Colors = Colors.Red
var health:int = 5

@onready var timer:Timer = $Timer
@onready var static_collision:CollisionShape2D = $StaticBody2D/SCollisionShape2D
@onready var area_collision:CollisionShape2D = $Area2D/ACollisionShape2D
@onready var explotion_animation:AnimatedSprite2D = $ExplotionAnim
@onready var explotion:CollisionShape2D = $Explotion/CollisionShape2D
@onready var fire:AnimatedSprite2D = $Fire
@onready var barrel:Sprite2D = $Barrel

func _on_area_2d_area_entered(area):
	if str(area)[0] == "B":
		health -= 1
		fire.visible = true
		fire.changeColor(color)
		if health == 0:
			explode()

func explode():
	static_collision.queue_free()
	area_collision.queue_free()
	barrel.queue_free()
	fire.visible = false
	explotion_animation.play("Explotion")
	explotion.scale = Vector2(1, 1)
	timer.start(0.5)

func _on_timer_timeout():
	queue_free()

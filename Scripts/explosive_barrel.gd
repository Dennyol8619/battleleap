extends Node2D

enum Colors {Red, Green, Blue, Purple, White, RandomColor}
var health:int = 5

@onready var timer:Timer = $Timer
@onready var static_collision:CollisionShape2D = $StaticBody2D/SCollisionShape2D
@onready var area_collision:CollisionShape2D = $Area2D/ACollisionShape2D
@onready var explotion_anim:AnimatedSprite2D = $ExplotionAnim
@onready var explotion:CollisionShape2D = $Explotion/CollisionShape2D
@onready var fire:AnimatedSprite2D = $Fire
@onready var barrel:Sprite2D = $Barrel

func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		health -= 1
		fire.visible = true
		match health:
			1: fire.changeColor(Colors.White)
			0: explode()
			_: fire.changeColor(Colors.Red)

func explode():
	static_collision.queue_free()
	area_collision.queue_free()
	barrel.queue_free()
	fire.visible = false
	explotion_anim.play("Explotion")
	explotion.scale = Vector2(1, 1)
	timer.start(0.5)

func _on_timer_timeout():
	queue_free()

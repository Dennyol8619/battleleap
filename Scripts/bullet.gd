extends Sprite2D

var bullet_speed:float = 1000
var bullet_direction:bool = true

func _physics_process(delta):
	if bullet_direction:
		position.x += bullet_speed * delta
		scale.x = 1
	else:
		position.x -= bullet_speed * delta
		scale.x = -1

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_body_entered(body):
	queue_free()

func get_direction(right:bool):
	bullet_direction = right

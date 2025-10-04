extends Sprite2D

const bullet_speed:float = 1000
var bullet_is_right:bool = true

func _physics_process(delta):
	if bullet_is_right:
		position.x += bullet_speed * delta
		scale.x = 4
	else:
		position.x -= bullet_speed * delta
		scale.x = -4

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_body_entered(_body):
	queue_free()

func set_direction(right:bool):
	bullet_is_right = right

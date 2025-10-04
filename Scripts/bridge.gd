extends Node2D

@onready var timer:Timer = $Timer

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		timer.start(1)

func _on_timer_timeout():
	queue_free()

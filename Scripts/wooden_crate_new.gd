extends RigidBody2D

var health:int = 5
@export_range(0,100) var droprate:int = 30
@onready var heal:PackedScene = preload("res://Prefabs/heal.tscn")
@onready var anim:Sprite2D = $Sprite2D

func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		health = max(0, health - 1)
		anim.frame = min(4, anim.frame + 1)
	elif area.is_in_group("explotion"):
		health = 0
		anim.frame = 4
	if health == 0:
		var rnum = randi_range(0, 100)
		if rnum < droprate:
			var heal_ins = heal.instantiate()
			get_parent().add_child(heal_ins)
			heal_ins.global_position = global_position
		queue_free()

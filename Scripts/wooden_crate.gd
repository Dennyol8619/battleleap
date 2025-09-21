extends Sprite2D

var health:int = 5
var heal_ins
var rnum
@export_range(0,100) var droprate:int = 30
@onready var heal = preload("res://Prefabs/heal.tscn")
var rng = RandomNumberGenerator.new()

func _on_area_2d_area_entered(area):
	if str(area)[0] == "B":
		health -= 1
		frame += 1
	elif str(area)[0] == "E":
		health = 0
		frame = 4
	if health == 0:
		rnum = rng.randi_range(0, 100)
		if rnum < droprate:
			heal_ins = heal.instantiate()
			get_parent().add_child(heal_ins)
			heal_ins.global_position = global_position
		queue_free()

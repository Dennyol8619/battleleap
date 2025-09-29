extends Node2D

@onready var ladder_base:PackedScene = preload("res://Prefabs/ladder_base.tscn")
@export_range(1, 16) var lenght:int = 1

func _ready():
	for i in range(lenght):
		var ladder_ins = ladder_base.instantiate()
		add_child(ladder_ins)
		ladder_ins.position = Vector2(0, -16 * i)

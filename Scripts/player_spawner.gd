extends Node2D

@export_range(1, 4) var id:int = 1
@onready var sprite:Sprite2D = $Sprite2D

func _ready():
	if get_tree().get_root().get_node("Root").get_meta("Player" + str(id)):
		var player_path:String = "res://Prefabs/Players/Player" + str(id) + "/player" + str(id) + ".tscn"
		var player_load = load(player_path)
		var player = player_load.instantiate()
		add_child(player)
	sprite.visible = false

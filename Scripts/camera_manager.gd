extends Camera2D

const padding:float = 10.0

@export var corner1:Marker2D
@export var corner2:Marker2D

func _process(_delta):
	#var ds:Vector2 = DisplayServer.window_get_size()
	var ds:Vector2 = get_viewport_rect().size
	global_position = (corner1.global_position + corner2.global_position) * 0.5
	var zoom_factor_x = abs(corner1.global_position.x-corner2.global_position.x)/(ds.x - padding)
	var zoom_factor_y = abs(corner1.global_position.y-corner2.global_position.y)/(ds.y - padding)
	var zoom_factor = max(max(zoom_factor_x, zoom_factor_y), 0.1)
	zoom = Vector2(1/zoom_factor, 1/zoom_factor)

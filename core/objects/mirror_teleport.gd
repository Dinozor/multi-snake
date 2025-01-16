class_name MirrorTeleport
extends MapObject


func collided(position: Vector2i, snake: Snake, _map: Map) -> void:
	var new_position = position
	var size := _map._map_size_center_r + Vector2i(1, 1)
	if position.x < -size.x:
		new_position.x = size.x + 1
	elif position.x > size.x:
		new_position.x = -size.x - 1
	if position.y < -size.y:
		new_position.y = size.y + 1
	elif position.y > size.y:
		new_position.y = -size.y - 1
	snake.move_head(new_position)

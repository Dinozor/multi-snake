class_name Wall
extends MapObject


func collided(_position: Vector2i, snake: Snake, _map: Map) -> void:
	snake.damage()

class_name Food
extends MapObject


@export var size_increase: int = 1
@export var remove_on_collide: bool = true


func collided(position: Vector2i, snake: Snake, _map: Map) -> void:
	snake.increase_size(size_increase)
	if remove_on_collide:
		_map.remove_object(position)

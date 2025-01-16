extends Node


signal snake_spawned(snake: Snake)
signal snake_changed(snake: Snake, size_change: int)
signal snake_moved(snake: Snake, current_position: Vector2i)
signal snake_damaged(snake: Snake)
signal snake_died(snake: Snake) 
signal object_spawned(object: MapObject, map: Map, pos: Vector2i)
signal game_speed_changed(new_speed: float)


func emit_snake_spawned(snake: Snake) -> void:
	snake_spawned.emit(snake)


func emit_snake_changed(snake: Snake, size_change: int = 1) -> void:
	snake_changed.emit(snake, size_change)


func emit_snake_moved(snake: Snake, current_position: Vector2i) -> void:
	snake_moved.emit(snake, current_position)
	
	
func emit_snake_damaged(snake: Snake) -> void:
	snake_damaged.emit(snake)


func emit_snake_died(snake: Snake) -> void:
	snake_died.emit(snake)


func emit_object_spawned(object: MapObject, map: Map, pos: Vector2i) -> void:
	object_spawned.emit(object, map, pos)


func emit_game_speed_changed(new_speed: float) -> void:
	game_speed_changed.emit(new_speed)

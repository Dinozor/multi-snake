class_name CoinObject
extends Node2D

#extends MapObject


@export var size_increase: int = 1
@export var remove_on_collide: bool = true


func _ready() -> void:
	pass
	#var timer = get_tree().create_timer(3.0)
	#timer.timeout.connect(_self_free)


func collided(_pos: Vector2i, snake: Snake, _map: Map) -> void:
	snake.increase_size(size_increase)
	if remove_on_collide:
		_map.remove_object(position)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		position += Vector2(20, 0)


func _self_free() -> void:
	pass
	#position += Vector2(10.0, 10.0)
	#queue_free()

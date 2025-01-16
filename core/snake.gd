class_name Snake
extends Resource


signal snake_moved()
signal snake_head_moved()
signal size_changed(amount: int)
signal damaged()
signal died()

@export var snake_tileset_index: int = 0
@export var head_texture_tile: Vector2i
@export var body_texture_tile: Vector2i

var head: Vector2i:
	get:
		return _body[_head_pointer]
var length: int = 1:
	get:
		return _body.size()
var body: Array[Vector2i]:
	get:
		return _body
var _head_pointer: int = 0
var _body: Array[Vector2i] = [Vector2i.ZERO]
var _direction: Vector2i = Vector2i.ZERO
var _next_direction: Vector2i


func move() -> void:
	var new_pos := calculate_next_position()
	_head_pointer = _head_pointer + 1
	if _head_pointer >= _body.size():
		_head_pointer = 0
	_body[_head_pointer] = new_pos
	snake_moved.emit()


func stop() -> void:
	_direction = Vector2i.ZERO
	_next_direction = Vector2i.ZERO


func update_direction() -> void:
	_update_new_direction()


func move_head(pos: Vector2i) -> void:
	_body[_head_pointer] = pos
	snake_head_moved.emit()


func size() -> int:
	return _body.size()


func increase_size(amount: int = 1) -> void:
	var _body_left := _body.slice(0, _head_pointer)
	for i in range(amount):
		_body_left.push_back(_body[_head_pointer])
	_body = _body_left + _body.slice(_head_pointer)
	size_changed.emit(amount)


func change_dir(new_direction: Vector2i) -> void:
	_next_direction = new_direction


func calculate_next_position() -> Vector2i:
	return _body[_head_pointer] + _direction


func damage() -> void:
	damaged.emit()


func die() -> void:
	died.emit()


func _update_new_direction() -> void:
	if _next_direction.x == 0:
		_direction.x = _next_direction.x
	else:
		if _direction.x == 0:
			_direction.x = _next_direction.x

	if _next_direction.y == 0:
		_direction.y = _next_direction.y
	else:
		if _direction.y == 0:
			_direction.y = _next_direction.y

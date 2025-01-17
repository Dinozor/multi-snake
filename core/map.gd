class_name Map
extends Node2D


enum ObjectType {
	NONE,
	WALL,
	SIMPLE_FOOD,
	TELEPORT_MIRROR
}

@export var map_size: Vector2i = Vector2i.ZERO
@export var _map: TileMapLayer
@export var _snake_layer: TileMapLayer
@export var source_id: int = 0
@export var food_index: Vector2i
@export var object_layer_name: String = "objects"

var _map_size_center_r : Vector2i


func _ready() -> void:
	assert(_map)
	#food_spawn_timer.timeout.connect(_on_food_spawn_timer_timeout)
	_map_size_center_r = map_size / 2 


func add_snake(snake: Snake) -> void:
	_snake_layer.add_snake(snake)


func pixel_to_cell(pos: Vector2) -> Vector2i:
	return _map.local_to_map(pos)


func update() -> void:
	pass


func get_object(pos: Vector2i) -> MapObject:
	var data = _map.get_cell_tile_data(pos)
	if data:
		var map_object = data.get_custom_data(object_layer_name)
		if map_object is MapObject:
			return map_object
	return null


func add_object(obj: MapObject, pos: Vector2i) -> void:
	_map.set_cell(pos, obj.tileset_index, obj.tile_coordinate)


func remove_object(pos: Vector2i) -> void:
	_map.set_cell(pos)


func is_snake(pos: Vector2i) -> bool:
	var atlas := _snake_layer.get_cell_atlas_coords(pos)
	if atlas != Vector2i(-1, -1):
		return true
	return false


func get_random_map_position() -> Vector2i:
	var x := randi_range(-_map_size_center_r.x, _map_size_center_r.x)
	var y := randi_range(-_map_size_center_r.y, _map_size_center_r.y)
	return Vector2i(x, y)

#func remove_food(pos: Vector2i) -> bool:
	#if not is_food(pos):
		#return false
	#_map.set_cell(pos)
	#return true


#func add_food(pos: Vector2i) -> void:
	#_map.set_cell(pos, source_id, food_index)


#func is_wall(pos: Vector2i) -> bool:
	#var data = _map.get_cell_tile_data(pos)
	#if data:
		#var map_object = data.get_custom_data(object_layer_name)
		#return map_object is Wall
	#return false


#func is_food(pos: Vector2i) -> bool:
	#var data = _map.get_cell_tile_data(pos)
	#if data:
		#var map_object = data.get_custom_data(object_layer_name)
		#return map_object is Food
	#return false


#func spawn_random_food() -> void:
	#var x := randi_range(-_map_size_center_r.x, _map_size_center_r.x)
	#var y := randi_range(-_map_size_center_r.y, _map_size_center_r.y)
	#add_food(Vector2i(x, y))

#func _on_food_spawn_timer_timeout() -> void:
	#spawn_random_food()

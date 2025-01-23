class_name Map
extends Node2D


@export var map_size: Vector2i = Vector2i.ZERO
@export var _map: SceneTileMapLayer
@export var _snake_layer: TileMapLayer
@export var source_id: int = 0
@export var food_index: Vector2i
@export var object_layer_name: String = "objects"

var _map_size_center_r : Vector2i


func _ready() -> void:
	assert(_map)
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


func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pass
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		delete_clicket_tile()


func delete_clicket_tile():
	var clicked_cell = _map.local_to_map(_map.get_local_mouse_position())
	_map.set_cell(clicked_cell)


func get_scene(pos: Vector2i) -> CoinObject:
	var node := _map.get_cell_scene(pos)
	if node is CoinObject:
		return node
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

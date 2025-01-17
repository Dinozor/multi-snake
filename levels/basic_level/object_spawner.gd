class_name ObjectSpawner
extends Node


@export var map_object: MapObject
@export var map: Map


func spawn() -> void:
	var pos = map.get_random_map_position()
	map.add_object(map_object, pos)

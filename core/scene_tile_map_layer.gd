extends TileMapLayer
class_name SceneTileMapLayer


const META_NAME = &"tile_coords"

var scene_coords: Dictionary[Vector2i, Node] = {}


func _enter_tree() -> void:
	child_entered_tree.connect(_register_child)
	child_exiting_tree.connect(_unregister_child)


func _register_child(child: Node2D) -> void:
	await child.ready
	var coords = local_to_map(to_local(child.global_position))
	scene_coords[coords] = child
	child.set_meta(META_NAME, coords)


func _unregister_child(child: Node2D) -> void:
	scene_coords.erase(child.get_meta(META_NAME))


func get_cell_scene(coords: Vector2i) -> Node:
	return scene_coords.get(coords, null)

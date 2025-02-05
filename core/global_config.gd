extends Node


@export var _main_menu: PackedScene


func change_scene_to_main_menu() -> void:
	if _main_menu:
		get_tree().change_scene_to_packed(_main_menu)

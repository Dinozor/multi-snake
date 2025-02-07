extends Node


@export var _main_menu: PackedScene

@onready var error_panel: PopupPanel = $ErrorPanel


func change_scene_to_main_menu() -> void:
	if _main_menu:
		get_tree().change_scene_to_packed(_main_menu)


func throw_error(message: String, on_close: Callable = Callable()) -> void:
	error_panel.show_error(message, on_close)


## Show error message and return to the main menu
func crash(message: String) -> void:
	throw_error(message, change_scene_to_main_menu)

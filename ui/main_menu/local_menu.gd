extends VBoxContainer


@export var _lobby_scene: PackedScene

@onready var _single_button: Button = %SingleButton
@onready var _versus_button: Button = %VersusButton


func _ready() -> void:
	_single_button.pressed.connect(_on_single_button_pressed)
	_versus_button.pressed.connect(_on_versus_button_pressed)


func _on_single_button_pressed() -> void:
	# TODO: Start the level as single player or allow map selection?
	pass


func _on_versus_button_pressed() -> void:
	get_tree().change_scene_to_packed(_lobby_scene)

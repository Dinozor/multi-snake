extends Control


const BASIC_LEVEL = preload("res://levels/basic_level/basic_level.tscn")

@onready var start_button: Button = %StartButton
@onready var exit_button: Button = %ExitButton
@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton


func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	exit_button.pressed.connect(_on_exit_pressed)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(BASIC_LEVEL)


func _on_exit_pressed() -> void:
	get_tree().quit()

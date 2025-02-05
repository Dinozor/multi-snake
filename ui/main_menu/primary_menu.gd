extends VBoxContainer


@export var _local_menu: VBoxContainer
@export var _multiplayer_menu: VBoxContainer

@onready var _local_button: Button = %LocalButton
@onready var _multiplayer_button: Button = %MultiplayerButton
@onready var _exit_button: Button = %ExitButton


func _ready() -> void:
	_local_button.pressed.connect(_on_local_button_pressed)
	_multiplayer_button.pressed.connect(_on_multiplayer_button_pressed)
	_exit_button.pressed.connect(_on_exit_pressed)


func _on_local_button_pressed() -> void:
	hide()
	_local_menu.show()


func _on_multiplayer_button_pressed() -> void:
	hide()
	_multiplayer_menu.show()


func _on_exit_pressed() -> void:
	get_tree().quit()

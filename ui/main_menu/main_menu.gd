extends Control


@onready var _back_button: Button = %BackButton
@onready var _primary_menu: VBoxContainer = %PrimaryMenu
@onready var _local_menu: VBoxContainer = %LocalMenu
@onready var _multiplayer_menu: VBoxContainer = %MultiplayerMenu


func _ready() -> void:
	_back_button.pressed.connect(_on_back_button_pressed)
	_primary_menu.hidden.connect(_on_primary_menu_hidden)
	show_primary()


func show_primary() -> void:
	_primary_menu.show()
	_local_menu.hide()
	_multiplayer_menu.hide()
	_back_button.hide()


func _on_back_button_pressed() -> void:
	show_primary()


func _on_primary_menu_hidden() -> void:
	_back_button.show()

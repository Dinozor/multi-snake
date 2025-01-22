extends Control

const MAIN_MENU_PATH = "res://ui/main_menu.tscn"

var _event_bus: EventBus = EventBus

@onready var _length: Label = %LenghtValue
@onready var _game_speed_value: Label = %GameSpeedValue
@onready var game_over_panel: PanelContainer = %GameOverPanel
@onready var main_menu_button: Button = %MainMenuButton
@onready var play_again_button: Button = %PlayAgainButton


func _ready() -> void:
	game_over_panel.hide()
	_event_bus.snake_changed.connect(_on_snake_changed)
	_event_bus.game_speed_changed.connect(_on_game_speed_changed)
	_event_bus.snake_died.connect(_on_snake_died)
	
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	play_again_button.pressed.connect(_on_play_again_button_pressed)


func _on_snake_changed(snake: Snake, _size_changed: int) -> void:
	_length.text = str(snake.size())


func _on_game_speed_changed(new_speed: float) -> void:
	_game_speed_value.text = str(new_speed)


func _on_snake_died(_snake: Snake) -> void:
	game_over_panel.show()


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)


func _on_play_again_button_pressed() -> void:
	get_tree().reload_current_scene()

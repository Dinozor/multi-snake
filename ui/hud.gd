extends Control


var _event_bus: EventBus = EventBus

@onready var _length: Label = %LenghtValue
@onready var _game_speed_value: Label = %GameSpeedValue


func _ready() -> void:
	_event_bus.snake_changed.connect(_on_snake_changed)
	_event_bus.game_speed_changed.connect(_on_game_speed_changed)


func _on_snake_changed(snake: Snake, _size_changed: int) -> void:
	_length.text = str(snake.size())


func _on_game_speed_changed(new_speed: float) -> void:
	_game_speed_value.text = str(new_speed)

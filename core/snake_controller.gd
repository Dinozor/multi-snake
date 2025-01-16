extends Node


@export var snake_tileset_index: int = 0
@export var snake_head_tile: Vector2i
@export var snake_body_tile: Vector2i

var _snake: Snake
var _event_bus: EventBus = EventBus


func _ready() -> void:
	set_process_unhandled_input(false)
	call_deferred(&"start")


func start() -> void:
	_snake = Snake.new()
	_snake.snake_tileset_index = snake_tileset_index
	_snake.body_texture_tile = snake_body_tile
	_snake.head_texture_tile = snake_head_tile
	_event_bus.emit_snake_spawned(_snake)
	set_process_unhandled_input(true)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"up"):
		_snake.change_dir(Vector2i.UP)
	elif event.is_action(&"down"):
		_snake.change_dir(Vector2i.DOWN)
	elif event.is_action(&"left"):
		_snake.change_dir(Vector2i.LEFT)
	elif event.is_action(&"right"):
		_snake.change_dir(Vector2i.RIGHT)

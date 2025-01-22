extends Node


@export var snake_tileset_index: int = 0
@export var snake_head_tile: Vector2i
@export var snake_body_tile: Vector2i
@export var is_keyboard: bool = true
@export var device_id: int = 0

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
	_snake.died.connect(_on_snake_died)


func _unhandled_input(event: InputEvent) -> void:
	if event.device != device_id:
		return
	if is_keyboard:
		if not (event is InputEventKey):
			return
	else:
		if event is InputEventKey:
			return

	#if event is InputEventKey:
		#if event.pressed and event.keycode == KEY_ESCAPE:
			#get_tree().quit()

	if event.is_action(&"up"):
		_snake.change_dir(Vector2i.UP)
	elif event.is_action(&"down"):
		_snake.change_dir(Vector2i.DOWN)
	elif event.is_action(&"left"):
		_snake.change_dir(Vector2i.LEFT)
	elif event.is_action(&"right"):
		_snake.change_dir(Vector2i.RIGHT)
	
func _on_snake_died() -> void:
	set_process_unhandled_input(false)

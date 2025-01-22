class_name Game
extends Node2D


#signal level_won()
#signal snake_wall_hit(snake: Snake)
signal food_consumed()

@export var snake_controller: Node
@export var _map: Map
@export var _speed: float = 3.0

var _event_bus: EventBus = EventBus
var _snakes: Array[Snake]
var _timer: float = 1 / _speed
var _snake_free_spawn_locations: Array[Node2D]

@onready var snake_spawn_locations: Node = %SnakeSpawnLocations
@onready var food_spawner: ObjectSpawner = $FoodSpawner
@onready var food_spawn_timer: Timer = $FoodSpawnTimer


func _ready() -> void:
	_event_bus.snake_spawned.connect(_on_snake_spawned)
	_event_bus.emit_game_speed_changed(_speed)
	food_spawn_timer.timeout.connect(_on_food_spawn_timer_timeout)
	food_consumed.connect(_on_food_consumed)
	for node in snake_spawn_locations.get_children():
		_snake_free_spawn_locations.push_back(node)


func _process(delta: float) -> void:
	_timer -= delta
	if _timer > 0:
		return

	_timer = 1 / _speed
	for snake in _snakes:
		_move(snake)


func _move(snake: Snake) -> void:
	snake.update_direction()
	_check_snake_collissions(snake)
	_check_object_collissions(snake)
	snake.move()


func _on_snake_spawned(snake: Snake) -> void:
	var spawn_location = _snake_free_spawn_locations.pick_random()
	_snake_free_spawn_locations.erase(spawn_location)
	var cell_position = _map.pixel_to_cell(spawn_location.position)
	snake.move_head(cell_position)
	_map.add_snake(snake)
	snake.snake_moved.connect(_on_snake_moved.bind(snake))
	snake.damaged.connect(_on_snake_damaged.bind(snake))
	snake.died.connect(_on_snake_died.bind(snake))
	snake.size_changed.connect(_on_snake_size_changed.bind(snake))
	_snakes.push_back(snake)


func _on_snake_moved(_s: Snake) -> void:
	_map.update()


func _check_object_collissions(snake: Snake) -> void:
	var head := snake.calculate_next_position()
	var map_object := _map.get_object(head)
	if map_object:
		map_object.collided(head, snake, _map)
		if map_object is Food:
			food_consumed.emit()


func _check_snake_collissions(snake: Snake) -> void:
	if not snake.is_moving():
		return
	var head := snake.calculate_next_position()
	if _map.is_snake(head):
		snake.damage()


func _on_snake_damaged(snake: Snake) -> void:
	_event_bus.emit_snake_damaged(snake)
	snake.stop()
	snake.die()


func _on_snake_died(snake: Snake) -> void:
	snake.stop()
	_event_bus.emit_snake_died(snake)


func _on_snake_size_changed(size_change: int, snake: Snake) -> void:
	_event_bus.emit_snake_changed(snake, size_change)


func _on_food_consumed() -> void:
	food_spawner.spawn()
	food_spawn_timer.start(food_spawn_timer.wait_time)

func _on_food_spawn_timer_timeout() -> void:
	food_spawner.spawn()

class_name Level
extends Node2D


signal level_started()
signal level_finished(winner: Snake)
#signal player_ready(player: Player)


@export var snake_controller: Node
@export var _map: Map
@export var _speed: float = 3.0

var _event_bus: EventBus = EventBus
var _snakes: Array[Snake]
var _timer: float = 1 / _speed
var _snake_free_spawn_locations: Array[Node2D]

@onready var snake_spawn_locations: Node = %SnakeSpawnLocations
#@onready var food_spawner: ObjectSpawner = $FoodSpawner
#@onready var food_spawn_timer: Timer = $FoodSpawnTimer

func start() -> void:
	level_started.emit()


func finish(winner: Snake) -> void:
	level_finished.emit(winner)

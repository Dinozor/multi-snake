extends TileMapLayer


@export var _snakes: Array[Snake]


func _ready() -> void:
	clear()


func _process(_delta: float) -> void:
	update()


func add_snake(snake: Snake) -> void:
	_snakes.push_back(snake)


func remove_snake(snake: Snake) -> void:
	_snakes.erase(snake)


func update() -> void:
	clear()
	for snake in _snakes:
		_draw_snake(snake)


func _draw_snake(snake: Snake) -> void:
	var index := snake.snake_tileset_index
	var head_tile := snake.head_texture_tile
	var body_tile := snake.body_texture_tile
	var head := snake.head
	for tile in snake.body:
		set_cell(tile, index, body_tile)
	set_cell(head, index, head_tile)

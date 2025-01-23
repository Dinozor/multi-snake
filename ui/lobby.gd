extends Control

const MAIN_MENU_PATH = "res://ui/main_menu.tscn"
const BASIC_LEVEL = preload("res://levels/basic_level/basic_level.tscn")
const PLAYER_CONTAINER = preload("res://ui/player_container.tscn")

var _network_lobby: NetworkLobby = NetworkLobby

@onready var leave_button: Button = %LeaveButton
@onready var start_game_button: Button = %StartGameButton
@onready var connected_players_container: VBoxContainer = %ConnectedPlayersContainer


func _ready() -> void:
	leave_button.pressed.connect(_on_leave_lobby_pressed)
	
	start_game_button.pressed.connect(_on_start_button_pressed)
	
	_network_lobby.player_connected.connect(_on_player_connected)
	_network_lobby.player_disconnected.connect(_on_player_disconnected)
	
	_refresh_lobby()


func _refresh_lobby() -> void:
	for child in connected_players_container.get_children():
		child.queue_free()
	for player in _network_lobby.players.values():
		_add_player(player)


func _add_player(player_info: PlayerInfo) -> void:
	var player_scene = PLAYER_CONTAINER.instantiate()
	player_scene.set_player(player_info)
	connected_players_container.add_child(player_scene)


func _on_player_connected(_peer_id, player_info) -> void:
	_add_player(player_info)


func _on_player_disconnected(peer_id: int) -> void:
	_refresh_lobby()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(BASIC_LEVEL)


func _on_leave_lobby_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)

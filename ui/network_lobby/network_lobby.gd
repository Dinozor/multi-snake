extends Control


const PlayerContainer = preload("res://ui/network_lobby/player_container.gd")

@export var  _levels: Array[PackedScene]
@export var _player_container: PackedScene

var _global_config: GlobalConfig = GlobalConfig
var _network_lobby: NetworkLobby = NetworkLobby
var _device_manager: DeviceManager = DeviceManager

@onready var leave_button: Button = %LeaveButton
@onready var start_game_button: Button = %StartGameButton
@onready var add_player_button: Button = %AddPlayerButton
@onready var connected_players_container: VBoxContainer = %ConnectedPlayersContainer
@onready var error_label: Label = %ErrorLabel
@onready var button: Button = %Button
@onready var error_panel: PopupPanel = %ErrorPanel


func _ready() -> void:
	leave_button.pressed.connect(_on_leave_lobby_pressed)
	_network_lobby.server_disconnected.connect(_on_server_disconnnected)

	#if not _network_lobby.is_server():
		#return
	_device_manager.controller_connected.connect(_on_controllers_changed)
	_device_manager.controller_disconnected.connect(_on_controllers_changed)
	
	add_player_button.pressed.connect(_on_add_player_button)

	start_game_button.pressed.connect(_on_start_button_pressed)

	_network_lobby.player_connected.connect(_on_player_connected)
	_network_lobby.player_disconnected.connect(_on_player_disconnected)

	add_player_button.disabled = true
	start_game_button.visible = true

	start_game_button.hide()

	_refresh_lobby()


func _refresh_lobby() -> void:
	for child in connected_players_container.get_children():
		child.queue_free()
	for player_id in _network_lobby.players.keys():
		_add_player(_network_lobby.players[player_id], player_id)


func _add_player(player_info: PlayerInfo, player_id: int) -> void:
	var player_scene = _player_container.instantiate() as PlayerContainer
	player_scene.set_player_info(player_info)
	player_scene.name = str(player_id)
	player_scene.set_multiplayer_authority(player_id)
	
	connected_players_container.add_child(player_scene)
	player_scene.set_device_options(_device_manager.get_devices())
	
	if _network_lobby.is_server() and not player_scene.is_multiplayer_authority():
		player_scene.remove_player_button.show()
		player_scene.remove_player_button.pressed.connect(
				_on_player_remove_button_pressed.bind(player_id)
		)
	else:
		player_scene.remove_player_button.hide()


func _refresh_player_device_options() -> void:
	var devices = _device_manager.get_devices()
	for player in connected_players_container.get_children():
		if player.has_method(&"set_device_options"):
			player.set_device_options(devices)


func _on_player_connected(peer_id, player_info) -> void:
	_add_player(player_info, peer_id)


func _on_player_disconnected(peer_id: int) -> void:
	var node = connected_players_container.get_node(str(peer_id))
	if node:
		node.queue_free()


func _on_server_disconnnected() -> void:
	error_label.text = "Server connection error! (Server disconnected or you got kicked)"
	error_panel.show()
	await error_panel.popup_hide
	error_panel.hide()
	_global_config.change_scene_to_main_menu()


func _on_add_player_button() -> void:
	var player_info := PlayerInfo.new("Player")
	player_info.is_local = true
	#_add_player(player_info)


func _on_controllers_changed(_id: int) -> void:
	_refresh_player_device_options()


func _on_player_remove_button_pressed(player_id: int) -> void:
	_network_lobby.disconnect_player(player_id)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(_levels[0])


func _on_leave_lobby_pressed() -> void:
	_global_config.change_scene_to_main_menu()

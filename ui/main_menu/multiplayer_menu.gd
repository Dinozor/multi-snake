extends VBoxContainer


@export var _lobby_path: PackedScene

var _network_lobby: NetworkLobby = NetworkLobby

@onready var _host_button: Button = %HostButton
@onready var _join_button: Button = %JoinButton
@onready var _player_name_edit: LineEdit = %PlayerNameEdit
@onready var _target_ip_edit: LineEdit = %TargetIPEdit
@onready var _max_players: SpinBox = %MaxPlayers


func _ready() -> void:
	_host_button.pressed.connect(_on_host_button_pressed)
	_join_button.pressed.connect(_on_join_button_pressed)

	_network_lobby.remove_multiplayer_peer()
	_network_lobby.game_created.connect(_on_game_created)
	_network_lobby.joined_server.connect(_on_joined)

	if OS.has_environment("USERNAME"):
		_player_name_edit.text = OS.get_environment("USERNAME")
	else:
		var desktop_path = OS.get_system_dir(OS.SystemDir.SYSTEM_DIR_DESKTOP)
		desktop_path = desktop_path.replace("\\", "/").split("/")
		_player_name_edit.text = desktop_path[desktop_path.size() - 2]


func _on_game_created() -> void:
	get_tree().change_scene_to_packed(_lobby_path)


func _on_joined() -> void:
	get_tree().change_scene_to_packed(_lobby_path)


func _on_host_button_pressed() -> void:
	_network_lobby.player_info.name = _player_name_edit.text
	_network_lobby.create_game(int(_max_players.value))


func _on_join_button_pressed() -> void:
	_network_lobby.player_info.name = _player_name_edit.text
	_network_lobby.join_game(_target_ip_edit.text)

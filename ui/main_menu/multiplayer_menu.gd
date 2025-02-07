extends VBoxContainer


@export var _lobby_path: PackedScene

var _network_lobby: NetworkLobby = NetworkLobby
var _global_config: GlobalConfig = GlobalConfig
var _join_label_text: String = "Join"

@onready var _host_button: Button = %HostButton
@onready var _join_button: Button = %JoinButton
@onready var _player_name_edit: LineEdit = %PlayerNameEdit
@onready var _target_ip_edit: LineEdit = %TargetIPEdit
@onready var _max_players: SpinBox = %MaxPlayers
@onready var _port_box: SpinBox = %PortBox
@onready var _show_target_ip_button: Button = %ShowTargetIPButton


func _ready() -> void:
	_join_label_text = _join_button.text
	_host_button.pressed.connect(_on_host_button_pressed)
	_join_button.pressed.connect(_on_join_button_pressed)

	_show_target_ip_button.button_down.connect(_on_show_target_ip_button_pressed)
	_show_target_ip_button.button_up.connect(_on_show_target_ip_button_released)

	_network_lobby.remove_multiplayer_peer()
	_network_lobby.game_created.connect(_on_game_created)
	_network_lobby.join_succeeded.connect(_on_join_succeeded)
	_network_lobby.join_failed.connect(_on_join_failed)

	if OS.has_environment("USERNAME"):
		_player_name_edit.text = OS.get_environment("USERNAME")
	else:
		var desktop_path = OS.get_system_dir(OS.SystemDir.SYSTEM_DIR_DESKTOP)
		desktop_path = desktop_path.replace("\\", "/").split("/")
		_player_name_edit.text = desktop_path[desktop_path.size() - 2]


func _on_game_created() -> void:
	get_tree().change_scene_to_packed(_lobby_path)


func _on_join_succeeded() -> void:
	_join_button.text = _join_label_text
	get_tree().change_scene_to_packed(_lobby_path)


func _on_join_failed() -> void:
	_join_button.text = _join_label_text
	_global_config.throw_error("Could not join the server")


func _on_host_button_pressed() -> void:
	_network_lobby.player_info.name = _player_name_edit.text
	var error = _network_lobby.create_game(int(_max_players.value), int(_port_box.value))
	if error:
		_global_config.throw_error(error_string(error))


func _on_join_button_pressed() -> void:
	_network_lobby.player_info.name = _player_name_edit.text
	var error = _network_lobby.join_game(_target_ip_edit.text, int(_port_box.value))
	if error:
		_global_config.throw_error(error_string(error))
	else:
		_join_button.text = "Joining ..."


func _on_show_target_ip_button_pressed() -> void:
	_target_ip_edit.secret = false


func _on_show_target_ip_button_released() -> void:
	_target_ip_edit.secret = true

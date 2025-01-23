extends Control


const BASIC_LEVEL = preload("res://levels/basic_level/basic_level.tscn")
const LOBBY_PATH = "res://ui/lobby.tscn"

var _network_lobby: NetworkLobby = NetworkLobby

@onready var primary_menu: VBoxContainer = %PrimaryMenu
@onready var local_menu: VBoxContainer = %LocalMenu
@onready var multiplayer_menu: VBoxContainer = %MultiplayerMenu

@onready var local_button: Button = %LocalButton
@onready var multiplayer_button: Button = %MultiplayerButton

@onready var single_button: Button = %SingleButton
@onready var versus_button: Button = %VersusButton

@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton
@onready var player_name_edit: LineEdit = %PlayerNameEdit
@onready var target_ip_edit: LineEdit = %TargetIPEdit

@onready var back_from_local_button: Button = %BackFromLocalButton
@onready var back_from_multiplayer_button: Button = %BackFromMultiplayerButton
@onready var exit_button: Button = %ExitButton


func _ready() -> void:
	local_button.pressed.connect(_on_local_button_pressed)
	multiplayer_button.pressed.connect(_on_multiplayer_button_pressed)

	back_from_local_button.pressed.connect(_on_main_menu_button_pressed)
	back_from_multiplayer_button.pressed.connect(_on_main_menu_button_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

	single_button.pressed.connect(_on_single_button_pressed)
	versus_button.pressed.connect(_on_versus_button_pressed)

	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)

	_network_lobby.remove_multiplayer_peer()
	_network_lobby.player_connected.connect(_on_player_connected)

	_on_main_menu_button_pressed()


func _on_main_menu_button_pressed() -> void:
	primary_menu.show()
	local_menu.hide()
	multiplayer_menu.hide()


func _on_local_button_pressed() -> void:
	primary_menu.hide()
	local_menu.show()
	multiplayer_menu.hide()
	#get_tree().change_scene_to_packed(BASIC_LEVEL)


func _on_single_button_pressed() -> void:
	# TODO: Start the level as single player or allow map selection?
	pass


func _on_versus_button_pressed() -> void:
	get_tree().change_scene_to_file(LOBBY_PATH)


func _on_multiplayer_button_pressed() -> void:
	primary_menu.hide()
	local_menu.hide()
	multiplayer_menu.show()


func _on_host_button_pressed() -> void:
	_network_lobby.player_info.name = player_name_edit.text
	_network_lobby.create_game()


func _on_join_button_pressed() -> void:
	_network_lobby.player_info.name = player_name_edit.text
	_network_lobby.join_game(target_ip_edit.text)


func _on_player_connected(peer_id, _player_info) -> void:
	if peer_id == 1:
		get_tree().change_scene_to_file(LOBBY_PATH)
	else:
		get_tree().change_scene_to_file(LOBBY_PATH)


func _on_exit_pressed() -> void:
	get_tree().quit()

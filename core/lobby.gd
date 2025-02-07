extends Node
# Autoload named Lobby
# Default build in timeout values (ms) for ENet are:
# ENET_PEER_TIMEOUT_LIMIT = 32
# ENET_PEER_TIMEOUT_MINIMUM = 5000
# ENET_PEER_TIMEOUT_MAXIMUM = 30000


# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id: int, player_info: PlayerInfo)
signal player_disconnected(peer_id: int)
signal server_disconnected()
signal game_created()
signal join_succeeded()
signal join_failed()
signal error_occured(error: Error)

const MAX_CONNECTIONS = 12

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players: Dictionary[int, PlayerInfo]

# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info: PlayerInfo = PlayerInfo.new("Player 1", -1)

var players_loaded = 0


func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func is_active() -> bool:
	return multiplayer.multiplayer_peer != null


func is_server() -> bool:
	return multiplayer.is_server()


func join_game(address, port: int) -> Error:
	var peer := ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	if error:
		return error
	
	# hack to change connection timeouts
	#var enet_peer := peer.host.get_peers().front() as ENetPacketPeer
	#enet_peer.set_timeout(32, 5000, 10000) # set max timeout to 10 seconds
	multiplayer.multiplayer_peer = peer
	return OK


func create_game(max_players: int = 1, port: int = 7000) -> Error:
	var peer = ENetMultiplayerPeer.new()
	var m = max_players if max_players < MAX_CONNECTIONS else MAX_CONNECTIONS
	var error = peer.create_server(port, m - 1)
	if error:
		error_occured.emit(error)
		return error
	multiplayer.multiplayer_peer = peer
	players[1] = PlayerInfo.new(player_info.name, 1)
	game_created.emit()
	player_connected.emit(1, player_info)
	return OK


func remove_multiplayer_peer() -> void:
	multiplayer.multiplayer_peer = null


func remove_player(player: PlayerInfo) -> void:
	var peer = players.find_key(player)
	multiplayer.multiplayer_peer.disconnect_peer(peer)


func disconnect_player(player_id: int) -> void:
	if multiplayer.get_peers().has(player_id):
		multiplayer.multiplayer_peer.disconnect_peer(player_id)


# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path) -> void:
	get_tree().change_scene_to_file(game_scene_path)


# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded() -> void:
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			# TODO: Somehow start the game
			#$/root/Game.start_game()
			players_loaded = 0


# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id) -> void:
	prints(multiplayer.get_unique_id(), "_on_player_connected", id)
	_register_player.rpc_id(id, player_info.serialize())


@rpc("any_peer", "reliable")
func _register_player(new_player_info_data: Dictionary) -> void:
	prints(multiplayer.get_unique_id(), "_register_player", new_player_info_data)
	var new_player_id = multiplayer.get_remote_sender_id()
	var new_player_info = PlayerInfo.new(new_player_info_data.get("name", ""), new_player_id)
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id) -> void:
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok() -> void:
	join_succeeded.emit()
	prints(multiplayer.get_unique_id(), "Connected to a server")
	var peer_id = multiplayer.get_unique_id()
	player_info = PlayerInfo.new(player_info.name, peer_id)
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail() -> void:
	printerr("On connected failed")
	join_failed.emit()
	multiplayer.multiplayer_peer = null


func _on_server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

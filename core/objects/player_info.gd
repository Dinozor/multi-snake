class_name PlayerInfo
extends RefCounted


@export var _network_id: int = -1
@export var name: String


func _init(player_name: String = "", id: int = -1) -> void:
	name = player_name
	_network_id = id


func serialize() -> Dictionary:
	return {"id": _network_id, "name": name}


func deserialize(data: Dictionary) -> void:
	name = data.get("name", "")
	_network_id = data.get("id", -1)


func get_network_id() -> int:
	return _network_id


static func create_from_dictionary(data: Dictionary) -> PlayerInfo:
	return PlayerInfo.new(data.get("name", ""), data.get("id", -1))

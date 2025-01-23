class_name PlayerInfo
extends RefCounted


@export var name: String


func _init(player_name: String = "") -> void:
	name = player_name


func serialize() -> Dictionary:
	return {"name": name}


func deserialize(data: Dictionary) -> void:
	name = data.get("name", "")


static func create_from_dictionary(data: Dictionary) -> PlayerInfo:
	return PlayerInfo.new(data.get("name", ""))

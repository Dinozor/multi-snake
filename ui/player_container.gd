extends HBoxContainer


var _player: PlayerInfo
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	name_label.text = _player.name


func set_player(player: PlayerInfo) -> void:
	_player = player
	if is_node_ready():
		name_label.text = _player.name

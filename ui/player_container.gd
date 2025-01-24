extends HBoxContainer


signal removed_pressed()
signal device_changed(new_device_id: int)
signal name_changed(new_name: String)


var _player: PlayerInfo

@onready var name_label: LineEdit = %NameLabel
@onready var remove_player_button: Button = %RemovePlayerButton
@onready var device_option_button: OptionButton = %DeviceOptionButton


func _ready() -> void:
	remove_player_button.pressed.connect(_on_remove_player_button_pressed)
	device_option_button.item_selected.connect(_on_device_changed)
	name_label.text_submitted.connect(_on_name_changed)
	if not _player:
		return
	name_label.text = _player.name
	if _player.is_local:
		name_label.editable = true
		device_option_button.disabled = false
	else:
		device_option_button.clear()
		device_option_button.add_item("Network Player")
		device_option_button.select(0)
		device_option_button.disabled = true
		name_label.editable = false
		


func set_player(player: PlayerInfo) -> void:
	_player = player
	if is_node_ready():
		name_label.text = _player.name


func set_device_options(devices: Dictionary[int, String]) -> void:
	if not _player.is_local:
		return
	var current_device := device_option_button.get_item_id(device_option_button.selected)
	device_option_button.clear()
	for device in devices.keys():
		var label := "%d. %s" %[device, devices[device]]
		device_option_button.add_item(label, device)

	var index := device_option_button.get_item_index(current_device)
	device_option_button.selected = index


func _on_remove_player_button_pressed() -> void:
	removed_pressed.emit()


func _on_name_changed(new_text: String) -> void:
	_player.name = new_text
	name_changed.emit(new_text)


func _on_device_changed(index: int) -> void:
	var selected_device := device_option_button.get_item_id(index)
	device_changed.emit(selected_device)

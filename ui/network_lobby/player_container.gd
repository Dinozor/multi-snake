extends HBoxContainer


signal device_changed(new_device_id: int)
signal name_changed(new_name: String)
signal ready_status_changed(new_status: bool)

var _player_info: PlayerInfo

@onready var name_label: LineEdit = %NameLabel
@onready var remove_player_button: Button = %RemovePlayerButton
@onready var device_option_button: OptionButton = %DeviceOptionButton
@onready var ready_check_box: CheckBox = %ReadyCheckBox
@onready var player_id: Label = %PlayerID
@onready var authority_id: Label = %AuthorityID


func _ready() -> void:
	assert(_player_info, "PlayerInfo must be set before _ready")
	name_label.text = _player_info.name
	
	device_option_button.item_selected.connect(_on_device_changed)
	name_label.text_submitted.connect(_on_name_changed)
	ready_check_box.toggled.connect(_on_ready_checkbox_toggled)

	player_id.text = "Player ID: %s" %name
	authority_id.text = "Authority: %d" %get_multiplayer_authority()

	if is_multiplayer_authority():
		name_label.editable = true
		ready_check_box.disabled = false
	else:
		name_label.editable = false
		ready_check_box.disabled = true


func set_player_info(info: PlayerInfo) -> void:
	_player_info = info


func set_device_options(devices: Dictionary[int, String]) -> void:
	var current_device := device_option_button.get_item_id(device_option_button.selected)
	device_option_button.clear()
	for device in devices.keys():
		var label := "%d. %s" %[device, devices[device]]
		device_option_button.add_item(label, device)

	var index := device_option_button.get_item_index(current_device)
	device_option_button.selected = index


func is_ready() -> bool:
	return ready_check_box.button_pressed


func _on_name_changed(new_text: String) -> void:
	_player_info.name = new_text
	name_changed.emit(new_text)


func _on_device_changed(index: int) -> void:
	var selected_device := device_option_button.get_item_id(index)
	device_changed.emit(selected_device)


func _on_ready_checkbox_toggled(toggled_on: bool) -> void:
	ready_status_changed.emit(toggled_on)

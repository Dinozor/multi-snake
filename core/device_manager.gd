extends Node


signal controller_connected(id: int)
signal controller_disconnected(id: int)


var _joypads: Dictionary[int, String]
## Default devices. Hight ID to not collide if anything
var _other: Dictionary[int, String] = {
	1000: "Keyboard",
	1001: "Mouse"
}


func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	_refresh_devices()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		_refresh_devices()


func get_devices() -> Dictionary[int, String]:
	return _joypads


func _on_joy_connection_changed(device: int, connected: bool) -> void:
	_refresh_devices()
	if connected:
		print_debug("Device %d connected" %device)
		controller_connected.emit(device)
	else:
		print_debug("Device %d disconnected" %device)
		controller_disconnected.emit(device)


func _refresh_devices() -> void:
	_joypads = _other
	for joypad in Input.get_connected_joypads():
		_joypads[joypad] = Input.get_joy_name(joypad)

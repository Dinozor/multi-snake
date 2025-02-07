extends PopupPanel


@onready var button: Button = %Button
@onready var error_label: Label = %ErrorLabel


func _ready() -> void:
	close_requested.connect(_on_close_requested)
	button.pressed.connect(_on_button_pressed)


func show_error(error: String, callback: Callable) -> void:
	error_label.text = error
	show()
	await popup_hide
	hide()
	if callback.is_valid():
		callback.call()


func _on_close_requested() -> void:
	hide()


func _on_button_pressed() -> void:
	hide()

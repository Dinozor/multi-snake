extends PopupPanel


@onready var button: Button = %Button


func _ready() -> void:
	close_requested.connect(_on_close_requested)
	button.pressed.connect(_on_butteon_pressed)


func _on_close_requested() -> void:
	hide()


func _on_butteon_pressed() -> void:
	hide()

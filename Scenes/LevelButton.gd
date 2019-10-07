extends Button

signal level_button_pressed(level)

func _on_pressed() -> void:
	emit_signal("level_button_pressed", int(name))

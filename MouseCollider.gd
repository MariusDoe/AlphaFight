extends Area2D

signal camera_move_start(pos)

signal camera_move_end(pos)

func _on_mouse_entered() -> void:
	emit_signal("camera_move_start", position)

func _on_mouse_exited() -> void:
	emit_signal("camera_move_end", position)
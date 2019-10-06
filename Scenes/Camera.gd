extends Camera2D

var speed = 200
var scaleFactor = 0.1

signal zoom_changed

func _process(delta: float) -> void:
	var pos = get_viewport().get_mouse_position()
	var rect = get_viewport_rect()
	var center = (rect.position + rect.end) / 2
	if not rect.grow(-50).has_point(pos):
		position += (pos - center).normalized() * speed * zoom.x * delta

func _input(event: InputEvent) -> void:
	if event.is_action("ui_scroll_up"):
		zoom *= exp(-scaleFactor)
		emit_signal("zoom_changed")
	if event.is_action("ui_scroll_down"):
		zoom *= exp(scaleFactor)
		emit_signal("zoom_changed")
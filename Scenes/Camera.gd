extends Camera2D

var speed = 50
var scaleFactor = 0.1

func _process(delta: float) -> void:
	var pos = get_viewport().get_mouse_position()
	var rect = get_viewport_rect()
	var center = (rect.position + rect.end) / 2
	if not rect.grow(-50).has_point(pos):
		position += (pos - center).normalized() * speed * zoom.x * delta
		print(zoom.x)

func _input(event: InputEvent) -> void:
	if event.is_action("ui_scroll_up"):
		zoom *= exp(-scaleFactor)
	if event.is_action("ui_scroll_down"):
		zoom *= exp(scaleFactor)
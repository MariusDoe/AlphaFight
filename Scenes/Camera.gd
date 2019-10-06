extends Camera2D

var speed = 50

func _process(delta: float) -> void:
	print("frame")
	var pos = get_viewport().get_mouse_position()
	var rect = get_viewport_rect()
	var center = (rect.position + rect.end) / 2
	if not rect.grow(-50).has_point(pos):
		position += (pos - center).normalized() * speed * delta
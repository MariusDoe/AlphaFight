extends Camera2D

var speed = 200
var scaleFactor = 0.1

signal zoom_changed

func _process(delta: float) -> void:
	var pos = get_viewport().get_mouse_position()
	var rect = get_viewport_rect()
	var center = (rect.position + rect.end) / 2
	var viewportSize = get_viewport().size
	var grow = min(viewportSize.x, viewportSize.y) * 0.1
	if not rect.grow(-grow).has_point(pos):
		position += (pos - center).normalized() * speed * zoom.x * delta
	$UI/Grid/PlayersValue.text = String(global.playerCount)
	$UI/Grid/EnemiesValue.text = String(global.enemyCount)
	$UI/Grid/WaitingValue.text = String(global.waitingCount)
	$UI.rect_position = -viewportSize / 2 * zoom
	$UI.rect_size = viewportSize
	$UI.rect_scale = zoom

func _input(event: InputEvent) -> void:
	if event.is_action("ui_scroll_up"):
		zoom *= exp(-scaleFactor)
		emit_signal("zoom_changed")
	if event.is_action("ui_scroll_down"):
		zoom *= exp(scaleFactor)
		emit_signal("zoom_changed")
extends Camera2D

var target = position
var speed = 50

func _on_camera_move_start(pos: Vector2) -> void:
	target += pos
	print(target)

func _on_camera_move_end(pos) -> void:
	target -= pos
	print(target)

func _physics_process(delta: float) -> void:
	if (target - position).length() < speed * delta:
		position = target
	else:
		position += (target - position).normalized() * speed * delta
extends Node2D

func setText(text: String):
	$Text.text = text

var target = position
var speed = 100

func setTarget(pos: Vector2):
	target = pos

func _physics_process(delta: float) -> void:
	if (target - position).length() < speed * delta:
		position = target
	else:
		position += (target - position).normalized() * speed * delta
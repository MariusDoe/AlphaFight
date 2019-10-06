extends Node2D

func setText(text: String):
	$Text.text = text

var target = position
var speed = 100
var finished = true

func setPos(pos: Vector2):
	position = pos
	finished = false

func setTarget(pos: Vector2):
	target = pos
	finished = false

func _physics_process(delta: float) -> void:
	if finished:
		return
	if (target - position).length() < speed * delta:
		position = target
		finished = true
	else:
		position += (target - position).normalized() * speed * delta
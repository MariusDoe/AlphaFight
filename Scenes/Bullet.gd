extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dir = Vector2(0, 0)
var speed = 200
var isEnemy = false
var lifetime = 2

func setTarget(pos: Vector2):
	dir = pos - position

func setEnemy(isEnemy):
	self.isEnemy = isEnemy

func setPos(pos: Vector2):
	position = pos

func _ready():
	pass

func _physics_process(delta: float) -> void:
	lifetime -= delta
	position += dir.normalized() * speed * delta
	if lifetime <= 0:
		free()
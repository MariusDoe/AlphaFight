extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target = null
var speed = 100
var enemy = false
func setTarget(pos: Vector2):
	target = pos
func set_enemy(is_enemy):
	enemy = is_enemy
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(delta: float) -> void:
	if not (target - position).length() < speed * delta:
		position += ((target - position).normalized() * speed * delta)
	elif target != null:
		print("delete_self")
		self.free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

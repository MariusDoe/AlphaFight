extends Node2D

var drag = false
var start = Vector2()
var end = Vector2()
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("dragging"):
		drag = true
		start = self.get_global_mouse_position()
	if drag:
		end = self.get_global_mouse_position()
		#draw_area()
	if Input.is_action_just_released("dragging"):
		print("select units")
		drag = false
		start = Vector2()
		end = Vector2()
	update()
func _draw():
	print("draw_rect")
	draw_rect(Rect2(start, end - start), Color(1,0,0, 0.2))
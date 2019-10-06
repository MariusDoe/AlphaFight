extends Node2D

var drag = false
var start = Vector2()
var end = Vector2()

signal new_selection

func _ready():
	connect_to_particles()

func _process(delta):
	if Input.is_action_just_pressed("dragging"):
		drag = true
		start = get_global_mouse_position()#get_local_mouse_position()
	if drag:
		end = get_global_mouse_position()#get_local_mouse_position()
		#draw_area()
	if Input.is_action_just_released("dragging"):
		emit_signal("new_selection", Rect2(start, end - start))
		drag = false
		start = Vector2()
		end = Vector2()
	update()
	
func _draw():
	var view_rect = get_viewport_rect()
	var center = (view_rect.position + view_rect.end) / 2
	draw_rect(Rect2(start - center, end - start), Color(1, 0, 0, 0.2))

func connect_to_particles():
	var x = get_tree().get_nodes_in_group("Selectable")
	for node in x:
		connect("new_selection", node, "_on_try_select")
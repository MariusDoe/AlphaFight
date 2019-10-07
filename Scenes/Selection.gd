extends Node2D

var drag = false
var globalStart = Vector2()
var globalEnd = Vector2()
var globalTopLeft
var globalBottomRight
var localStart = Vector2()
var localEnd = Vector2()
var localTopLeft
var localBottomRight
var camera

signal new_selection

func _ready():
	connect_to_particles()
	camera = get_tree().root.get_node("Game/Camera2D")
	updateGlobalCorners()
	updateLocalCorners()

func _process(delta):
	if Input.is_action_just_pressed("dragging"):
		drag = true
		globalStart = get_global_mouse_position()
		localStart = get_local_mouse_position()
		updateLocalCorners()
	if drag:
		globalEnd = get_global_mouse_position()
		localEnd = get_local_mouse_position()
		updateLocalCorners()
	if Input.is_action_just_released("dragging"):
		updateGlobalCorners()
		emit_signal("new_selection", Rect2(globalTopLeft, globalBottomRight - globalTopLeft))
		drag = false
		globalStart = Vector2()
		globalEnd = Vector2()
		localStart = Vector2()
		localEnd = Vector2()
		updateLocalCorners()
	update()

func updateGlobalCorners():
	globalTopLeft = Vector2(min(globalStart.x, globalEnd.x), min(globalStart.y, globalEnd.y))
	globalBottomRight = Vector2(max(globalStart.x, globalEnd.x), max(globalStart.y, globalEnd.y))

func updateLocalCorners():
	localTopLeft = Vector2(min(localStart.x, localEnd.x), min(localStart.y, localEnd.y))
	localBottomRight = Vector2(max(localStart.x, localEnd.x), max(localStart.y, localEnd.y))

func _draw():
	#var view_rect = get_viewport_rect()
	#var center = (view_rect.position + view_rect.end) / 2
	#draw_rect(Rect2(start - center, end - start), Color(1, 0, 0, 0.2))

	draw_rect(Rect2(localTopLeft, localBottomRight - localTopLeft), Color(1, 0, 0, 0.2))

func connect_to_particles():
	var x = get_tree().get_nodes_in_group("Selectable")
	for node in x:
		var found = false
		for connection in get_signal_connection_list("new_selection"):
			if connection.target == node:
				found = true
				break
		if !found:
			connect("new_selection", node, "_on_try_select")
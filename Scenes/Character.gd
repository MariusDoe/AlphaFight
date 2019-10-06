extends KinematicBody2D

var index: int = 0

func _ready() -> void:
	get_tree().root.get_node("Game/Camera2D").connect("zoom_changed", self, "_on_zoom_changed")
	_on_zoom_changed()

func setIndex(i: int):
	index = i
	setText(char(index + 65))
	updateColor()

func setText(text: String):
	$Text.text = text
	
func setEnemy(is_enemy: bool):
	enemy = is_enemy
	updateColor()

func updateColor():
	var r = 0
	if enemy:
		r = 1
	setColor(Color(r, 1 - r, float(index) / 25))

var enemy = false
var target = position
var speed = 2

func setPos(pos: Vector2):
	position = pos

var selected = false

func setTarget(pos: Vector2):
	target = pos

func setColor(color: Color):
	$Text.add_color_override("font_color", color)
	$Square.color = color

func _process(delta):
	if selected:
		$Text.add_color_override("font_color_shadow", Color(1, 1, 0))
		$Text.add_constant_override("shadow_offset_x", 2)
		$Text.add_constant_override("shadow_offset_y", 2)
	else:
		$Text.add_color_override("font_color_shadow", Color(0, 0, 0))
		$Text.add_constant_override("shadow_offset_x", 0)
		$Text.add_constant_override("shadow_offset_y", 0)
	if Input.is_action_just_pressed("move_command") and selected:
		setTarget(self.get_global_mouse_position())

func _physics_process(delta: float) -> void:
	move_and_collide((target - position).clamped(speed))

#this function checks for selection
func check_selected(selection_rect):
	if enemy:
		return
	if selection_rect.has_point(position):
		selected = true
	else:
		selected = false
	$SelectedSquare.visible = $Square.visible and selected

func _on_zoom_changed():
	if $Text.get_canvas_transform().get_scale().length() < 1.2:
		$Text.visible = false
		$Square.visible = true
		$Square.scale = Vector2(1, 1) / $Square.get_canvas_transform().get_scale()
		$SelectedSquare.visible = selected
		$SelectedSquare.scale = Vector2(1, 1) / $SelectedSquare.get_canvas_transform().get_scale()
		$SelectedSquare.position = Vector2(2, 2) / $SelectedSquare.get_canvas_transform().get_scale()

	else:
		$Text.visible = true
		$Square.visible = false
		$SelectedSquare.visible = false
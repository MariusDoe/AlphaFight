extends KinematicBody2D

var index: int = 0

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
	if not (target - position).length() < speed * delta:
		move_and_collide((target - position).normalized() * speed)

#this function checks for selection
func check_selected(selection_rect):
	if enemy:
		return
	if selection_rect.has_point(position):
		selected = true
	else:
		selected = false
extends KinematicBody2D

func setText(text: String):
	$Text.text = text
	
func setEnemy(is_enemy: bool):
	enemy = is_enemy

var enemy = false
var target = position
var speed = 1
var selected = false

func setTarget(pos: Vector2):
	target = pos

func _process(delta):
	if selected:
		$Text.add_color_override("font_color", Color(1,0,0,1))
	else:
		$Text.add_color_override("font_color", Color(0,0,0,1))
	if Input.is_action_just_pressed("move_command") and selected:
		setTarget(self.get_global_mouse_position())

func _physics_process(delta: float) -> void:
	if not (target - position).length() < speed * delta:
		move_and_collide((target - position).normalized() * speed)


#this function checks for selection
func check_selected(selection_rect):
	if selection_rect.has_point(position):
		selected = true
	else:
		selected = false
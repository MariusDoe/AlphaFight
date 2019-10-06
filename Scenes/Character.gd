extends KinematicBody2D

var index: int = 0

func setIndex(i: int):
	index = i
	setText(char(index + 65))
	speed = 2 + 1 * ((25-i)/25)
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
var opponents_in_range = []
var Bullet = preload("res://Scenes/Bullet.tscn")
var time_ellapsed = 0
var destroy = false

func setPos(pos: Vector2):
	position = pos

var selected = false

func setTarget(pos: Vector2):
	target = pos

func setColor(color: Color):
	$Text.add_color_override("font_color", color)

func _process(delta):
	time_ellapsed += delta
	if time_ellapsed > 1 + (index/25) * 2:
		if len(opponents_in_range) > 0:
			handle_shoot()
			time_ellapsed = 0
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
	test_range()
func test_range():
	if $Text.text == "N" and not enemy:
		print(opponents_in_range)

func _physics_process(delta: float) -> void:
	if not (target - position).length() < speed * delta:
		move_and_collide((target - position).normalized() * speed)
	if destroy == true:
		free()

#this function checks for selection
func check_selected(selection_rect):
	if enemy:
		return
	if selection_rect.has_point(position):
		selected = true
	else:
		selected = false

func handle_shoot():
	index = randi()%len(opponents_in_range)
	var b = Bullet.instance()
	b.set_enemy(enemy)
	b.position = position
	b.setTarget(opponents_in_range[index].position)
	self.get_parent().add_child(b)


func _on_Area2D_body_entered(body):
	if body.enemy != enemy:
		opponents_in_range.append(body)
		

func _on_Area2D_body_exited(body):
	if body.enemy != enemy:
		opponents_in_range.erase(body)
		

func _on_Hitbox_area_entered(area):
	if area.get_parent().get_groups()[0] != "Selectable" and area.get_parent().enemy != enemy:
		#bullet enters
		area.get_parent().free()
		destroy = true
		pass # Replace with function body.


extends KinematicBody2D

var index: int = 0
var selected = false
var life = 0
var isEnemy = false
var target = position
var speed = 0
var charactersInRange = []
var Bullet = preload("res://Scenes/Bullet.tscn")
var timeSinceLastShot = 0
var reloadTime = 0
var destroy = false
var cacheDidntFindOpponent = false
var intent = Vector2(0,0)

signal character_dying(character)

func _ready() -> void:
	randomize()
	intent = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()
	updateLife()
	get_tree().root.get_node("Game/Camera2D").connect("zoom_changed", self, "_on_zoom_changed")
	_on_zoom_changed()

func setIndex(i: int):
	index = i
	setText(char(index + 65))
	speed = 2 + 1 * ((25-i)/25)
	speed *= 10
	updateColor()
	updateLife()
	updateReloadTime()

func updateLife():
	life = float(index) / 25 * 10 + 5

func updateColor():
	var r = 0
	if isEnemy:
		r = 1
	setColor(Color(r, 1 - r, float(index) / 25))

func updateReloadTime():
	reloadTime = 1.0 / (26 - index) + 0.5

func setText(text: String):
	$Text.text = text
	
func setEnemy(isEnemy: bool):
	self.isEnemy = isEnemy
	updateColor()

func setPos(pos: Vector2):
	position = pos

func setTarget(pos: Vector2):
	target = pos

func setColor(color: Color):
	$Text.add_color_override("font_color", color)
	$Square.color = color

func isOpponent(thing):
	return thing.isEnemy != isEnemy

func handleDying():
	if isEnemy:
		if life <= 0:
			setEnemy(false)
			updateLife()
	else:
		if life <= 0:
			destroy = true
			emit_signal("character_dying", self)

func _process(delta):
	timeSinceLastShot += delta
	if timeSinceLastShot > reloadTime:
		tryShoot()
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

func _calculate_movement(delta):
	var sum_pos = Vector2(0,0)
	var number_enemys = 0
	for partic in charactersInRange:
		if partic.isEnemy:
			number_enemys += 1
			sum_pos += partic.position - position
	var middle_pos = sum_pos/ number_enemys
	
	var sum_intents = Vector2(0,0)
	for partic in charactersInRange:
		if partic.isEnemy:
			sum_intents += partic.intent
	var middle_intent = sum_intents/ number_enemys
	intent =  (middle_intent * 2 + Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()).normalized()
	
	
	if number_enemys == len(charactersInRange):
		move_and_collide((200 * intent + middle_pos).clamped(speed))
	else:
		var sum_opponent = Vector2(0,0)
		for partic in charactersInRange:
			if partic.isEnemy == false:
				sum_opponent += partic.position - position
		var middle_opponent = sum_opponent/ (len(charactersInRange) - number_enemys)
		
		move_and_collide((20*intent + middle_pos + middle_opponent * 40).clamped(speed))
	
func _physics_process(delta: float) -> void:
	if isEnemy:
		_calculate_movement(delta)
		target = position
	else:
		move_and_collide((target - position).clamped(speed))
	if destroy == true:
		free()

#this function checks for selection
func _on_try_select(selection_rect):
	if isEnemy:
		return
	if selection_rect.has_point(position):
		selected = true
	else:
		selected = false
	$SelectedSquare.visible = $Square.visible and selected

func _on_zoom_changed():
	if $Text.get_canvas_transform().get_scale().length() < 0.3:
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

func tryShoot():
	if charactersInRange.size() == 0:
		return
	if cacheDidntFindOpponent:
		return
	var foundOpponent = false
	for character in charactersInRange:
		if isOpponent(character):
			foundOpponent = true
			break
	if !foundOpponent:
		cacheDidntFindOpponent = true
		return
	var i = 0
	while true:
		i = randi() % charactersInRange.size()
		var character = charactersInRange[i]
		if isOpponent(character):
			shoot(character.position)
			break

func shoot(where: Vector2):
	var b = Bullet.instance()
	b.setEnemy(isEnemy)
	b.setPos(position)
	b.setTarget(where)
	get_parent().add_child(b)
	timeSinceLastShot = 0

func _on_Area2D_body_entered(body):
	charactersInRange.append(body)
	cacheDidntFindOpponent = false

func _on_Area2D_body_exited(body):
	charactersInRange.erase(body)

func _on_Hitbox_area_entered(area):
	var bullet = area.get_parent()
	if !bullet.get_groups().has("Selectable") and isOpponent(bullet):
		# bullet enters
		bullet.free()
		life -= 1
		handleDying()
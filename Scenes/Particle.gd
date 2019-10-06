extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func check_selected(selection_rect):
	print("check_selected")
	if selection_rect.has_point(position):
		selected = true
	else:
		selected = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		$Sprite.visible = true
	else:
		$Sprite.visible = false

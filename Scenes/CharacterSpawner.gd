extends Node

onready var Character = preload("res://Character.tscn")

var characters = []

func _ready() -> void:
	for i in range(0, 26):
		var c = Character.instance()
		c.setText(char(i + 65))
		c.setTarget(Vector2(randf() * get_viewport().get_visible_rect().size.x, randf() * get_viewport().get_visible_rect().size.x))
		add_child(c)
		characters.append(c)
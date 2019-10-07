extends Control

func _ready():
	var levels = $Start/VBox/Scroll/Levels
	var button = levels.get_node("1")
	for i in range(global.maxLevel):
		var b
		if i == 0:
			b = button
		else:
			b = button.duplicate()
		var s = String(i + 1)
		if global.highscores.has(s):
			b.text = s + " [" + formatTime(global.highscores[s]) + "]"
		else:
			b.text = s + " [??:??:??.???]"
		b.name = s
		if i != 0:
			levels.add_child(b)
	$Start/VBox/Scroll.scroll_vertical = global.lastScrollPos
	if global.jumpToLevels:
		_on_Start_pressed()

func formatTime(time: float):
	var hours = floor(time / 3600)
	var minutes = floor(fmod(time / 60, 60))
	var seconds = floor(fmod(time, 60))
	var milliseconds = round(fmod(time, 1) * 1000)
	return "%02d:%02d:%02d.%03d" % [hours, minutes, seconds, milliseconds]

func _on_Start_pressed() -> void:
	$Main.visible = false
	$Start.visible = true

func _on_Credits_pressed() -> void:
	$Main.visible = false
	$Credits.visible = true

func _on_level_button_pressed(level: int) -> void:
	global.level = level
	global.lastScrollPos = $Start/VBox/Scroll.scroll_vertical
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_HowTo_pressed() -> void:
	$Main.visible = false
	$HowTo.visible = true

func _on_Back_pressed() -> void:
	$Start.visible = false
	$HowTo.visible = false
	$Credits.visible = false
	$Main.visible = true
extends Container

func _process(delta: float):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			hide()
		else:
			show()

func show():
	get_tree().paused = true
	visible = true

func hide():
	get_tree().paused = false
	visible = false

func _on_Resume_pressed() -> void:
	hide()

func _on_Return_pressed() -> void:
	hide()
	get_tree().change_scene("Scenes/MainMenu.tscn")
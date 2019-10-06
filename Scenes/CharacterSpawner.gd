extends Node

var Character = preload("res://Scenes/Character.tscn")

var wordsFilePath = "res://Data/all.txt"

func _ready() -> void:
	randomize()
	var wordsFile = File.new()
	wordsFile.open(wordsFilePath, File.READ)
	var words = wordsFile.get_as_text().split("\n")
	for i in range(20):
		spawnWord(words[randi() % words.size()], pointToRect(randomPointInRect(Rect2(-10000, -10000, 20000, 20000)), 50))

func pointToRect(point: Vector2, size: float):
	return Rect2(point, point).grow(size)

func stringToIndex(s: String):
	return s.to_ascii()[0] - 65

func spawnWord(word: String, rect: Rect2):
	for i in range(word.length()):
		spawnCharacter(stringToIndex(word[i]), randomPointInRect(rect), randomPointInRect(rect))

func spawnCharacter(index: int, pos: Vector2, target: Vector2):
	var c = Character.instance()
	c.setText(char(index + 65))
	c.setPos(pos)
	c.setTarget(target)
	add_child(c)

func randomPointInRect(rect: Rect2):
	return Vector2(rand_range(rect.position.x, rect.end.x), rand_range(rect.position.y, rect.end.y))
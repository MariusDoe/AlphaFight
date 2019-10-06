extends Node

var Character = preload("res://Scenes/Character.tscn")

var wordsFilePath = "res://Data/all.txt"

func _ready() -> void:
	randomize()
	spawnWord("NOTHING", pointToRect(center(get_viewport().get_visible_rect()), 100), false)
	var wordsFile = File.new()
	wordsFile.open(wordsFilePath, File.READ)
	var words = wordsFile.get_as_text().split("\n")
	for i in range(20):
		spawnWord(words[randi() % words.size()], pointToRect(randomPointInRect(Rect2(-10000, -10000, 20000, 20000)), 50), true)

func center(rect: Rect2):
	return (rect.position + rect.end) / 2

func pointToRect(point: Vector2, size: float):
	return Rect2(point, point).grow(size)

func stringToIndex(s: String):
	return s.to_ascii()[0] - 65

func spawnWord(word: String, rect: Rect2, is_enemy: bool):
	for i in range(word.length()):
		spawnCharacter(stringToIndex(word[i]), randomPointInRect(rect), randomPointInRect(rect), is_enemy)

func spawnCharacter(index: int, pos: Vector2, target: Vector2, is_enemy: bool):
	var c = Character.instance()
	c.setEnemy(is_enemy)
	c.setIndex(index)
	c.setPos(pos)
	c.setTarget(target)
	add_child(c)

func randomPointInRect(rect: Rect2):
	return Vector2(rand_range(rect.position.x, rect.end.x), rand_range(rect.position.y, rect.end.y))
extends Node

var Character = preload("res://Scenes/Character.tscn")

var wordsFilePath = "res://Data/all.txt"
var words = []

var spawnDistance = 3000
var spawnNestDist = 1000
var maxEnemyDist = 10000
var spawnAttemptInterval = 30
var timeSinceLastSpawnAttempt = spawnAttemptInterval

var characters = []
var averagePlayerCharacter = Vector2(0, 0)
var furthestPlayerCharacter = 0
var furthestEnemyCharacter = 0
var playerCount = 0
var enemyCount = 0

func _ready() -> void:
	randomize()
	spawnWord("NOTHING", pointToRect(center(get_viewport().get_visible_rect()), 100), false)
	var wordsFile = File.new()
	wordsFile.open(wordsFilePath, File.READ)
	words = wordsFile.get_as_text().split("\n")

func getCountForDistance(d: float):
	return ceil(max(0.04 * d, 1))

func getNestSizeForCount(c: int):
	return 10 * sqrt(c)

func _process(delta):
	timeSinceLastSpawnAttempt += delta
	if fmod(timeSinceLastSpawnAttempt, 1.0) < 0.1:
		print(spawnAttemptInterval - timeSinceLastSpawnAttempt)
	if timeSinceLastSpawnAttempt >= spawnAttemptInterval:
		trySpawn()

func trySpawn():
	print("try")
	averagePlayerCharacter = Vector2(0, 0)
	playerCount = 0
	enemyCount = 0
	for character in characters:
		if !character.isEnemy:
			averagePlayerCharacter += character.position
			playerCount += 1
		else:
			enemyCount += 1
	if playerCount == 0:
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		return
	averagePlayerCharacter /= playerCount
	for character in characters:
		var dist = character.position.distance_to(averagePlayerCharacter)
		if !character.isEnemy and dist > furthestPlayerCharacter:
			furthestPlayerCharacter = dist
		elif character.isEnemy:
			if dist > maxEnemyDist:
				character.destroy = true
			elif dist > furthestEnemyCharacter:
				furthestEnemyCharacter = dist
	if enemyCount == 0 or furthestEnemyCharacter - furthestPlayerCharacter < spawnDistance:
		spawnWave()
	timeSinceLastSpawnAttempt = 0
	get_tree().root.get_node("Game/Selection").connect_to_particles()

func spawnWave():
	var rad = furthestEnemyCharacter + spawnNestDist
	var count = ceil(2 * PI * rad / spawnNestDist)
	for i in range(count):
		var theta = 2 * PI / count * i
		var center = Vector2(rad * cos(theta), rad * sin(theta)) + averagePlayerCharacter
		spawnNest(center)

func spawnNest(center: Vector2):
	var count = getCountForDistance(center.distance_to(averagePlayerCharacter))
	print(center, count)
	var wordList = generateWordListForCount(count)
	var rect = pointToRect(center, getNestSizeForCount(count))
	for word in wordList:
		spawnWord(word, rect, true)

func generateWordListForCount(c: int):
	var wordList = []
	var total = 0
	while total < c:
		var word = words[randi() % words.size()]
		if word.length() + total <= c:
			wordList.append(word)
			total += word.length()
	return wordList

func center(rect: Rect2):
	return (rect.position + rect.end) / 2

func pointToRect(point: Vector2, size: float):
	return Rect2(point, point).grow(size)

func stringToIndex(s: String):
	return s.to_ascii()[0] - 65

func spawnWord(word: String, rect: Rect2, isEnemy: bool):
	for i in range(word.length()):
		spawnCharacter(stringToIndex(word[i]), randomPointInRect(rect), randomPointInRect(rect), isEnemy)

func spawnCharacter(index: int, pos: Vector2, target: Vector2, isEnemy: bool):
	var c = Character.instance()
	c.setEnemy(isEnemy)
	c.setIndex(index)
	c.setPos(pos)
	c.setTarget(target)
	add_child(c)
	characters.append(c)
	c.connect("character_dying", self, "_on_character_dying")

func _on_character_dying(character):
	characters.erase(character)

func randomPointInRect(rect: Rect2):
	return Vector2(rand_range(rect.position.x, rect.end.x), rand_range(rect.position.y, rect.end.y))
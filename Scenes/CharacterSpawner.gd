extends Node

var Character = preload("res://Scenes/Character.tscn")

var wordsFilePath = "res://Data/all.res"
var words = []

var playerCount = 0
var enemyCount = 0

var enemiesSpawned = 0
var enemiesToSpawn = -1
var spawnDistance = 1000
var maxEnemyDist = 5000
var minEnemyDistanceForSpawn = 200
var spawnAttemptInterval = 5
var timeSinceLastSpawnAttempt = spawnAttemptInterval
var time = 0

var characters = []
var averagePlayerCharacter = Vector2(0, 0)

func _ready() -> void:
	randomize()
	var cameraRect = get_tree().root.get_node("Game/Camera2D").get_viewport_rect()
	spawnWord("NOTHING", cameraRect, false)
	var wordsFile = File.new()
	wordsFile.open(wordsFilePath, File.READ)
	words = wordsFile.get_as_text().split("\n")
	wordsFile.close()
	enemiesToSpawn = getEnemiesToSpawn()

func getEnemiesToSpawn():
	return global.level * 20

func getCount():
	return clamp(ceil(float(enemiesSpawned) / enemiesToSpawn * global.level * 5), 1, enemiesToSpawn - enemiesSpawned)

func getNestSizeForCount(c: int):
	return 10 * sqrt(c)

func _process(delta: float):
	time += delta
	timeSinceLastSpawnAttempt += delta
	if timeSinceLastSpawnAttempt >= spawnAttemptInterval:
		trySpawn()

func won():
	global.maxLevel = max(global.maxLevel, global.level + 1)
	global.addHighscore(global.level, time)
	global.writeFile()
	goToMainMenu()

func lost():
	goToMainMenu()

func goToMainMenu():
	global.jumpToLevels = true
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func updatePlayerCount(diff: int):
	playerCount += diff
	global.playerCount = playerCount
	if playerCount == 0:
		lost()

func updateEnemyCount(diff: int):
	enemyCount += diff
	global.enemyCount = enemyCount
	if enemyCount == 0 and enemiesToSpawn - enemiesSpawned <= 0:
		won()
	updateWaitingCount()

func updateWaitingCount():
	global.waitingCount = enemiesToSpawn - enemiesSpawned

func trySpawn():
	averagePlayerCharacter = Vector2(0, 0)
	for character in characters:
		if !character.isEnemy:
			averagePlayerCharacter += character.position
	averagePlayerCharacter /= playerCount
	var nearestEnemyCharacter = INF
	for character in characters:
		var dist = character.position.distance_to(averagePlayerCharacter)
		if !character.isEnemy:
			pass
		elif character.isEnemy:
			if dist > maxEnemyDist:
				character.destroy = true
				enemiesSpawned -= 1
			elif dist < nearestEnemyCharacter:
				nearestEnemyCharacter = dist
	if enemyCount == 0 or nearestEnemyCharacter >= minEnemyDistanceForSpawn:
		spawnNest()
		get_tree().root.get_node("Game/Selection").connect_to_particles()
	timeSinceLastSpawnAttempt = 0

func spawnNest():
	var theta = rand_range(0, 2 * PI)
	var center = spawnDistance * Vector2(cos(theta), sin(theta)) + averagePlayerCharacter
	var count = getCount()
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
		spawnCharacter(stringToIndex(word[i]), randomPointInRect(rect), isEnemy)

func spawnCharacter(index: int, pos: Vector2, isEnemy: bool):
	var c = Character.instance()
	c.setEnemy(isEnemy)
	c.setIndex(index)
	c.setPos(pos)
	c.setTarget(pos)
	add_child(c)
	characters.append(c)
	c.connect("character_dying", self, "_on_character_dying")
	c.connect("character_converting", self, "_on_character_converting")
	if isEnemy:
		enemiesSpawned += 1
		updateEnemyCount(1)
	else:
		updatePlayerCount(1)

func _on_character_dying(character):
	characters.erase(character)
	if character.isEnemy:
		updateEnemyCount(-1)
	else:
		updatePlayerCount(-1)
	character.queue_free()

func _on_character_converting(character):
	updateEnemyCount(-1)
	updatePlayerCount(1)

func randomPointInRect(rect: Rect2):
	return Vector2(rand_range(rect.position.x, rect.end.x), rand_range(rect.position.y, rect.end.y))
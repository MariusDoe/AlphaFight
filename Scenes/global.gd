extends Node

var maxLevel = 1
var highscores = []

var level = -1
var filePath = "user://data.ini"
var jumpToLevels = false
var lastScrollPos = 0

var playerCount = 0
var enemyCount = 0
var waitingCount = 0

func _ready() -> void:
	loadFile()

func loadFile():
	var file = File.new()
	file.open(filePath, File.READ)
	var json = parse_json(file.get_as_text())
	var shouldWrite = false
	if json != null and json.has("level"):
		maxLevel = json["level"]
	else:
		maxLevel = 1
		shouldWrite = true
	if json != null and json.has("highscores") and typeof(json["highscores"]) == TYPE_DICTIONARY:
		highscores = json["highscores"]
	else:
		highscores = Dictionary()
		shouldWrite = true
	if shouldWrite:
		writeFile()
	file.close()

func getFileString():
	return to_json({
		"level": maxLevel,
		"highscores": highscores
	})

func writeFile():
	var file = File.new()
	file.open(filePath, File.WRITE)
	file.store_string(getFileString())
	file.close()

func addHighscore(level, time):
	level = String(level)
	if highscores.has(level):
		highscores[level] = min(time, highscores[level])
	else:
		highscores[level] = time
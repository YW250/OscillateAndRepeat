extends Node2D

@onready var menu = load("res://Scene/menu.tscn")
@onready var game = load("res://Scene/line.tscn")
@onready var file = "data.txt"
@onready var sound = get_node("Sound")

var level1:int = 0
var level2:int = 0
var level3:int = 0

var currentLevel
var giveCertificate:bool = false


var Sounds= {
	
	Draw = {
		
		"click1" : "res://Sounds/Line/click1.mp3",
		"click2" : "res://Sounds/Line/click2.mp3",
		"click3" : "res://Sounds/Line/click3.mp3",
		"click4" : "res://Sounds/Line/click4.mp3",
		"click5" : "res://Sounds/Line/click5.mp3",
		"click6" : "res://Sounds/Line/click6.mp3",
		"click7" : "res://Sounds/Line/click7.mp3",
		"click8" : "res://Sounds/Line/click8.mp3",
		
		
	},
	
	Menu = {
		
		"ButtonClick": "res://Sounds/Menu/ButtonClick.mp3",
		"ButtonSelect": "res://Sounds/Menu/ButtonSelect.mp3"
		
	}
	
}



func _ready():
	globalGeneral.sceneNode = self
	
	var fileArray = []
	if !FileAccess.file_exists(file):
		var newFile = FileAccess.open(file, FileAccess.WRITE)
		newFile.store_line("0")
		newFile.store_line("0")
		newFile.store_line("0")
		newFile.store_line("f")
		newFile.close()

	var thisFile = FileAccess.open(file, FileAccess.READ)
	fileArray.append(thisFile.get_line())
	fileArray.append(thisFile.get_line())
	fileArray.append(thisFile.get_line())
	thisFile.close()
	level1 = int(fileArray[0])
	level2 = int(fileArray[1])
	level3 = int(fileArray[2])
	newScene("Menu")
	


func newScene(which:String):
	for i in get_children():
		if i.name != "Sound" and i.name != "Music":
			i.queue_free()
	var newScene
	match which:
		"Menu":
			newScene = menu.instantiate()
			newScene.showPercent(level1, level2, level3)
			if giveCertificate == true:
				giveCertificate = false
				newScene.showLicense()
				lisenceMusic()
		"Game":
			newScene = game.instantiate()
			newScene.currentLevel = currentLevel
	add_child(newScene)


func updateSound(value):
	get_node("Sound").volume_db = value - 45


func updateMusic(value):
	get_node("Music").volume_db = value - 45


func lisenceMusic():
	get_node("Music").stop()
	get_node("Music").stream = load("res://Sounds/Music/catyy.mp3")
	get_node("Music").volume_db -= 10
	get_node("Music").play()

func lisenceStop():
	get_node("Music").stop()
	get_node("Music").stream = load("res://Sounds/Music/OscillateAndRepeat.mp3")
	get_node("Music").volume_db += 10
	get_node("Music").play()



func play(level:int):
	currentLevel = level
	newScene("Game")


func backToMenu():
	newScene("Menu")


func saveData(percent: int):
	print(currentLevel, "/", percent)
	var rememberLines = []
	var remFile = FileAccess.open(file, FileAccess.READ_WRITE)
	for i in 4:
		rememberLines.append(remFile.get_line())
	remFile.close()
	
	var editFile = FileAccess.open(file, FileAccess.READ_WRITE)
	match currentLevel:
		1:
			if level1 < percent:
				level1 = percent
				editFile.store_line(str(level1))
				editFile.store_string(rememberLines[1])
				editFile.get_line()
				editFile.store_string(rememberLines[2])
				editFile.get_line()
				editFile.store_string(rememberLines[3])
		2:
			editFile.get_line()
			if level2 < percent:
				level2 = percent
				editFile.store_line(str(level2))
				editFile.store_string(rememberLines[2] + "\n")
				editFile.store_string(rememberLines[3] + "\n")
				editFile.get_line()
		3:
			editFile.get_line()
			editFile.get_line()
			if level3 < percent:
				level3 = percent
				editFile.store_line(str(level3))
				editFile.store_string(rememberLines[3] + "\n")
	
	editFile.close()
	print(rememberLines[3])
	
	if rememberLines[3] == "f":
		if level1 >= 97 and level2 >= 97 and level3 >= 97:
			var editCert = FileAccess.open(file, FileAccess.READ_WRITE)
			editCert.get_line()
			editCert.get_line()
			editCert.get_line()
			editCert.store_line("t")
			giveCertificate = true
	
func playSound(which:String):
	match which:
		"Draw":
			var rand = randi_range(1, 8)
			sound.stream = load(Sounds["Draw"]["click"+str(rand)])
			sound.play()
		"Button":
			sound.stream = load(Sounds["Menu"]["ButtonClick"])
			sound.play()
		"Select":
			sound.stream = load(Sounds["Menu"]["ButtonSelect"])
			sound.play()
	


func _on_music_finished():
	get_node("Music").play()

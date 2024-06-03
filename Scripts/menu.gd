extends Node2D

@export var tutorial:Control

var showingTutorial:bool = false

var currentLevel:int = 1


func _ready():
	highlightLevel()


func highlightLevel():
	for i in 3:
		get_node("Levels").get_node(str(i+1)).modulate = Color8(255, 255, 255, 255)
	
	get_node("Levels").get_node(str(currentLevel)).modulate = Color8(255, 255, 0, 255)



func _on_start_pressed():
	if showingTutorial == false:
		globalGeneral.sceneNode.play(currentLevel)


func showPercent(one:int,two:int,three:int):
	get_node("Levels/1").get_node("Label").text = str(one) + "%"
	get_node("Levels/2").get_node("Label").text = str(two) + "%"
	get_node("Levels/3").get_node("Label").text = str(three) + "%"
	
	for i in 3:
		for i1 in 3:
			get_node("Rating").get_node(str(i+1)).get_node(str(i1+1)).modulate = Color8(255, 255, 255, 255)
	
	if one >= 80:
		get_node("Rating/1/1").modulate = Color8(255, 255, 0, 255)
		if one >= 90:
			get_node("Rating/1/2").modulate = Color8(255, 255, 0, 255)
			if one >= 97:
				get_node("Rating/1/3").modulate = Color8(255, 255, 0, 255)
	if two >= 80:
		get_node("Rating/2/1").modulate = Color8(255, 255, 0, 255)
		if two >= 90:
			get_node("Rating/2/2").modulate = Color8(255, 255, 0, 255)
			if two >= 97:
				get_node("Rating/2/3").modulate = Color8(255, 255, 0, 255)
	if three >= 80:
		get_node("Rating/3/1").modulate = Color8(255, 255, 0, 255)
		if three >= 90:
			get_node("Rating/3/2").modulate = Color8(255, 255, 0, 255)
			if three >= 97:
				get_node("Rating/3/3").modulate = Color8(255, 255, 0, 255)


func buttonSelect():
	globalGeneral.sceneNode.playSound("Select")


func sliderUpdate(who:String, value):
	match who:
		"Sounds":
			globalGeneral.sceneNode.updateSound(value)
		"Music":
			globalGeneral.sceneNode.updateMusic(value)



func showLicense():
	get_node("License").visible = true


func _on_button_pressed():
	globalGeneral.sceneNode.playSound("Button")
	showTutorial()


func showTutorial():
	showingTutorial = true
	tutorial.visible = true


func closeTutorial():
	globalGeneral.sceneNode.playSound("Button")
	showingTutorial = false
	tutorial.visible = false


func _on_close_pressed():
	globalGeneral.sceneNode.playSound("Button")
	closeTutorial()



func _on_1_pressed():
	globalGeneral.sceneNode.playSound("Button")
	currentLevel = 1
	highlightLevel()


func _on_2_pressed():
	globalGeneral.sceneNode.playSound("Button")
	currentLevel = 2
	highlightLevel()


func _on_3_pressed():
	globalGeneral.sceneNode.playSound("Button")
	currentLevel = 3
	highlightLevel()


func _on_close_license_pressed():
	globalGeneral.sceneNode.playSound("Button")
	globalGeneral.sceneNode.lisenceStop()
	get_node("License").visible = false

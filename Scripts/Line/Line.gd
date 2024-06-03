extends Node2D

@export var mainLine:Line2D
@export var testLine:Line2D
@export var testLine2:Line2D
@export var userLine:Line2D
@export var Answer:Label
@export var buttonReplay:Button
@export var buttonExit:Button

var userDraw:bool = false
var userVectorArray:PackedVector2Array
var userLastPoint:Vector2
var userFinished:bool = false
var justGenerated:bool = true

var currentLevel:int = 0



func _ready():
	generateLevel()
	



func _process(delta):
	
	if Input.is_action_just_released("mouse1"):
		if userFinished == false and justGenerated == false:
			userFinished = true
			calcTest()
			checkAccuracy()
			pointsEstimation()
	
	if Input.is_action_pressed("mouse1"):
		if userDraw == true and userFinished == false:
			print("falseFinish")
			var currentMousePos = get_global_mouse_position()
			if (currentMousePos - userLastPoint).length() > 10:
				userVectorArray.append(currentMousePos - userLine.position)
				userLine.points = userVectorArray
				userLastPoint = currentMousePos
				globalGeneral.sceneNode.playSound("Draw")
			if justGenerated == true:
				justGenerated = false


func generateLevel():
	justGenerated = true
	Answer.text = ""
	userFinished = false
	buttonReplay.visible = false
	buttonExit.visible = false
	mainLine.points = generateLine(currentLevel)
	var newVector:PackedVector2Array
	newVector.append(Vector2(0,0))
	newVector.append(Vector2(10,0))
	testLine.points = newVector
	userVectorArray.clear()
	userVectorArray.append(Vector2(0,0))
	userLine.points = userVectorArray
	userLastPoint = userLine.position - Vector2(0,0)


func generateLine(difficulty:int = 1):
	var newVector:PackedVector2Array
	newVector.append(Vector2(0, 0))
	match difficulty:
		1:
			var xCount = 1
			var yRemember = 0
			for i1 in 4:
				newVector.append(Vector2(xCount*100, 100*yRemember))
				yRemember = randi_range(-1, 1)
				newVector.append(Vector2(xCount*100, 100*yRemember))
				xCount += 1
		2:
			var xCount = 1
			var yRemember = 0
			for i1 in 7:
				newVector.append(Vector2(xCount*100, 100*yRemember))
				yRemember = randi_range(-1, 1)
				newVector.append(Vector2(xCount*100, 100*yRemember))
				xCount += 1
		3:
			var xCount = 1
			var yRemember = 0
			for i1 in 10:
				newVector.append(Vector2(xCount*100, 100*yRemember))
				yRemember = randi_range(-1, 1)
				newVector.append(Vector2(xCount*100, 100*yRemember))
				xCount += 1
		_:
			var xCount = 1
			var yRemember = 0
			for i1 in difficulty:
				newVector.append(Vector2(xCount*100, 100*yRemember))
				yRemember = randi_range(-1, 1)
				newVector.append(Vector2(xCount*100, 100*yRemember))
				xCount += 1
			
	return newVector


func calcTest():
	var testVector:PackedVector2Array
	testVector.append(Vector2(0,0))
	var currentY = 0
	var skip = true
	for i in mainLine.points:
		if skip == false:
			var matchValue = i.y
			if matchValue == 100:
				currentY += 50
			elif matchValue == -100:
				currentY -= 50
			else:
				pass
			var newVector:Vector2 = Vector2.ZERO
			newVector.x = i.x
			newVector.y = currentY
			testVector.append(newVector)
			skip = true
		else:
			skip = false
	testLine.points = testVector


func checkAccuracy():
	if userLine.points.size() >= testLine.points.size():
		divideTest2()
	else:
		print("Try more dots")
	


func divideTest2():
	var rememberVector:Vector2
	var rememberPrevious:Vector2
	var test2points:PackedVector2Array
	for i in testLine.points:
		var countTotal = 0
		var index = testLine.points.find(i)
		if index == 0:
			test2points.append(testLine.points[0])
			rememberPrevious = userLine.points[0]
		else:
			var count = 0
			for i1 in userLine.points:
				if ( i - i1 ).length() < ( i - rememberVector ).length():
					rememberVector = i1
				count += 1
				countTotal += 1
			var amountInbetween = userLine.points.find(rememberVector) - userLine.points.find(rememberPrevious)
			#var smallVector = (rememberVector - rememberPrevious)/amountInbetween
			var smallVector = (testLine.points[testLine.points.find(i)] - testLine.points[testLine.points.find(i)-1])/amountInbetween
			for i2 in amountInbetween:
				test2points.append(rememberPrevious + smallVector*(i2+1))
			print("Closest to ", i, " is ", rememberVector)
			rememberPrevious = rememberVector
	testLine2.points = test2points


func pointsEstimation():
	var estimation
	var arrayAccuracy = []
	if userLine.points.size() > 20:
		for i in userLine.points:
			var index = userLine.points.find(i)
			if index <= testLine2.points.size()-1:
				var vectorAccuracy = testLine2.points[index] - userLine.points[index]
				if vectorAccuracy.length() < 5:
					arrayAccuracy.append(100)
				elif vectorAccuracy.length() < 55:
					arrayAccuracy.append(100 - (vectorAccuracy.length()-5) * 2)
				else:
					arrayAccuracy.append(0)
		var sumAccuracy = 0
		for i in arrayAccuracy:
			sumAccuracy += i
		estimation = sumAccuracy/arrayAccuracy.size()
	else:
		estimation = 0
	Answer.text = "Presicion: " + str(int(estimation)) + "%"
	print(arrayAccuracy)
	buttonReplay.visible = true
	buttonExit.visible = true
	globalGeneral.sceneNode.saveData(int(estimation))


func _on_draw_zone_mouse_entered():
	userDraw = true




func _on_draw_zone_mouse_exited():
	userDraw = false


func _on_button_pressed():
	generateLevel()


func _on_exit_pressed():
	globalGeneral.sceneNode.backToMenu()

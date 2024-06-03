extends Node2D

@export var max:int = 100
@export var min:int = 0
@export var value:int = 100
@export var sliderName:String
@export var sendSignal:NodePath

@onready var slider:Sprite2D = get_node("Slider")
@onready var path:ColorRect = get_node("Path")
@onready var maxValue:RichTextLabel = get_node("maxValue")
@onready var minValue:RichTextLabel = get_node("minValue")
@onready var valueNumber:RichTextLabel = get_node("Value")
@onready var nameLabel:RichTextLabel = get_node("Name")

var selected = false
var mouseSelected = false
var bbCode = "[center]"


# Called when the node enters the scene tree for the first time.
func _ready():
	slider.position.y = 0
	slider.position.x = path.position.x
	maxValue.text = bbCode + str(max)
	minValue.text = bbCode + str(min)
	nameLabel.text = bbCode + sliderName
	valueNumber.visible = false


func _process(delta):
	if Input.is_action_pressed("mouse1") and selected == true:
		mouseSelected = true
		valueNumber.visible = true
	
	if Input.is_action_just_released("mouse1") and mouseSelected == true:
		mouseSelected = false
		valueNumber.visible = false
		
		
	if mouseSelected == true:
		var xpos = get_global_mouse_position().x - path.global_position.x
		if xpos >= 0 and xpos < 500:
			slider.position.x = xpos - 250
			valueNumber.position.x = xpos - 300
			value = abs(xpos / (500/max) - max)
		elif xpos < 0:
			slider.position.x = -250
			valueNumber.position.x = -300
			value = max
		elif xpos > 500:
			slider.position.x = 250
			valueNumber.position.x = 200
			value = min
		valueNumber.text = bbCode + str(value)
		sendValue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func sendValue():
	if get_node(sendSignal):
		get_node(sendSignal).sliderUpdate(self.name, value)


func _on_collision_mouse_entered():
	selected = true
	print("slider mouse entered")


func _on_collision_mouse_exited():
	selected = false
	print("slider mouse exited")

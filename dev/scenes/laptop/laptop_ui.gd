extends Node2D

@export var comedian_buttons : Array
var comedians
var container : VBoxContainer
var button


func _ready():
	setup()
	reset()

func setup():
	container = get_node("Container/HBoxContainer/Comedians/ScrollContainer/VBoxContainer")
	button = container.get_child(0)

func reset():
	comedians = ComedianPool.get_available_comedians(6)
	
	var newButton
	
	for comedian in comedians:
		newButton = button.duplicate()
		newButton.setup(comedian)
		newButton.text = comedian.name
		container.add_child(newButton)
	
	button.queue_free()

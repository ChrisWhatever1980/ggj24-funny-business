extends Node2D

@export var available_buttons : VBoxContainer
@export var booked_buttons : VBoxContainer
@export var stats_container : VBoxContainer
@export var book_button : Button
@export var start_button : Button
@export var budget : Label

var comedians
var selected_comedian
var active_button

func _ready():
	book_button.interface = self
	start_button.interface = self
	reset()

func reset():
	comedians = ComedianPool.get_available_comedians()
	budget.text = "$"+GameState.money
	
	for comedian in comedians:
		add_available(comedian)
		
	available_buttons.get_child(0)._on_button_up()

func add_available(comedian):
	var newButton = preload("res://scenes/laptop/comedian_button.tscn").instantiate()
	newButton.setup(comedian, self)
	newButton.text = comedian.name
	available_buttons.add_child(newButton)

func add_booked(comedian):
	var newButton = preload("res://scenes/laptop/comedian2_button.tscn").instantiate()
	newButton.setup(comedian, self)
	newButton.text = comedian.name
	booked_buttons.add_child(newButton)

func finalize_booking():
	ComedianPool.reset_selection()
	
	for button in booked_buttons.get_children():
		ComedianPool.select_comedian(button.comedian)
	
	print("Selected " + str(ComedianPool.selected.size()) + " comedians for the show!")

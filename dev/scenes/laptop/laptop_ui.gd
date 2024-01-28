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
	reset_infos()
	comedians = ComedianPool.get_available_comedians()
	budget.text = "$" + str(GameState.money)
	
	for comedian in comedians:
		add_available(comedian)

func reset_infos():
	stats_container.get_node("Name").text = ""
	stats_container.get_node("Cost").text = ""
	stats_container.get_node("Fame").text = ""
	stats_container.get_node("Comedy").text = ""
	stats_container.get_node("Endurance").text = ""

func add_available(comedian):
	var newButton = preload("res://scenes/laptop/comedian_button.tscn").instantiate()
	newButton.setup(comedian, self)
	newButton.text = comedian.name
	available_buttons.add_child(newButton)
	reset_infos()

func add_booked(comedian):
	var newButton = preload("res://scenes/laptop/comedian2_button.tscn").instantiate()
	newButton.setup(comedian, self)
	newButton.text = comedian.name
	booked_buttons.add_child(newButton)
	reset_infos()

func finalize_booking():
	ComedianPool.reset_selection()
	
	for button in booked_buttons.get_children():
		ComedianPool.select_comedian(button.comedian)
		button.queue_free()
	
	print("Selected " + str(ComedianPool.selected.size()) + " comedians for the show!")

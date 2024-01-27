extends Button

@export var book : bool = true

var interface
var stats_container : VBoxContainer
var book_button : Button
var comedian

func setup(c, ui):
	comedian = c
	interface = ui
	stats_container = ui.stats_container
	book_button = ui.book_button
	
func _on_button_up():
	interface.active_button = self
	stats_container.get_node("Name").text = comedian.name
	stats_container.get_node("Cost").text = "$" + str(comedian.cost)
	stats_container.get_node("Fame").text = "$" + str(comedian.fame)
	stats_container.get_node("Comedy").text = "$" + str(comedian.comedy)
	stats_container.get_node("Endurance").text = "$" + str(comedian.endurance)
	
	if book:
		book_button.set_booked(true)
	else:
		book_button.set_booked(false)
		

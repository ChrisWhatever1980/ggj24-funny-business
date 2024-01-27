extends Button

var book : bool = true
var interface

func set_booked( state : bool):
	book = state
	if book:
		text = "Book"
	else:
		text = "Cancel"

func _on_button_up():
	if book:
		interface.add_booked(interface.active_button.comedian)
		# remove money
		pass
	else:
		interface.add_available(interface.active_button.comedian)
		# add money
		pass
	
	interface.active_button.queue_free()

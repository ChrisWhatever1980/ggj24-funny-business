extends Button

var book : bool = true
var interface

func set_booked( state : bool):
	book = state
	disabled = false
	show()
	if book:
		text = "Book"
	else:
		text = "Cancel"

func _on_button_up():
	if book:
		if GameState.money > 0:
			interface.add_booked(interface.active_button.comedian)
			GameEvents.emit_signal("change_money", -interface.active_button.comedian.cost)
	else:
		interface.add_available(interface.active_button.comedian)
		GameEvents.emit_signal("change_money", interface.active_button.comedian.cost)
	
	interface.active_button.queue_free()
	disabled = true
	hide()

extends Button

var interface

func _on_button_up():
	interface.finalize_booking()
	GameEvents.emit_signal("start_show")

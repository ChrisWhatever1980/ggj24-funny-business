extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	print("Sacrifice!!")
	$underworld/TheDevil/AudioStreamPlayer3D.play()
	GameEvents.emit_signal("change_money", -1)
	
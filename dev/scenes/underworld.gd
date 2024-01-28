extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.emit_signal("comedian_judged", self, "on_comedian_judged")


func on_comedian_judged():
	$underworld/TheDevil/EvilLaughPlayer.play()

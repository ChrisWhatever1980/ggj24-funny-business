extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect_event("comedian_judged", self, "on_comedian_judged")
	GameEvents.connect_event("comedian_failed", self, "on_comedian_failed")


func on_comedian_judged():
	$underworld/TheDevil/EvilLaughPlayer.play()


func on_comedian_failed():
	$SoulFireParticles.emitting = true

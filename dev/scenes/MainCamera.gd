extends Node3D


var screen_shake_time = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect_event("screen_shake", self, "on_screen_shake")


func on_screen_shake(duration):
	#print("Shake screen")
	screen_shake_time = duration


func _process(delta):
	if screen_shake_time > 0.0:
		$Camera3D.position.x += sin(screen_shake_time * 100.0) * 0.1
		$Camera3D.position.y += cos(screen_shake_time * 100.0) * 0.1
		screen_shake_time -= delta
		if screen_shake_time <= 0.0:
			$Camera3D.position = Vector3.ZERO

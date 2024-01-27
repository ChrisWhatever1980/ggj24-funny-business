extends Node3D

@export var stats: Resource

var exiting = false
var to_exit = Vector3.ZERO
var exiting_speed = 5.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if exiting:
		position += to_exit * delta * exiting_speed

func _on_timer_timeout():
	var joke_quality = randi_range(0, 12)
	print("joke_quality: " + str(joke_quality))
	GameEvents.emit_signal("audience_react", joke_quality)


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				exiting = true
				$AnimationPlayer.stop()
				$Timer.stop()
				print("GET OFF THE STAGE!")
				to_exit = (get_parent().ComedianExit.position - position).normalized()

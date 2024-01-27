extends Node3D

#@export var stats: Resource
var stats = null

var performing = false
var waiting = true
var exiting = false
var entering = false
var to_target = Vector3.ZERO
var exiting_speed = 5.0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if exiting or entering:
		position += to_target * delta * exiting_speed


func _on_timer_timeout():
	if performing:
		var joke_quality = randi_range(0, 12)
		print("joke_quality: " + str(joke_quality))
		GameEvents.emit_signal("audience_react", joke_quality)


func begin_performance():
	entering = false
	performing = true
	get_parent().current_comedian = self
	$AnimationPlayer.play("comedian_routine")
	if randi() % 2 == 0:
		$StandupStream0.play()
	else:
		$StandupStream1.play()
	$Timer.start()


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if waiting:
					print("GET ON THE STAGE!")
					waiting = false
					entering = true
					to_target = (get_parent().StagePosition.position - position).normalized()
					to_target.y = 0.0
					to_target = to_target.normalized()

				if performing:
					get_parent().current_comedian = self
					performing = false
					exiting = true
					$AnimationPlayer.stop()
					$StandupStream0.stop()
					$StandupStream1.stop()
					$Timer.stop()
					print("GET OFF THE STAGE!")
					to_target = (get_parent().ComedianExit.position - position)
					to_target.y = 0.0
					to_target = to_target.normalized()
					GameEvents.emit_signal("audience_idle")

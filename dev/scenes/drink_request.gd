extends Area2D

signal fulfilled
signal timed_out

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$FailureProgressBar.value = $FailureTimer.time_left / $FailureTimer.wait_time


func _on_area_entered(area: Area2D):
	if area.is_in_group("Drinks"):
		area.add_request(self)
		
func _on_area_exited(area: Area2D):
	if area.is_in_group("Drinks"):
		area.remove_request(self)
		
func _on_failure_timer_timeout():
	timed_out.emit()
	disappear()

func highlight_fulfillable(fulfillable: bool):
	if fulfillable:
		$Sprite2D.modulate = Color.YELLOW
	else:
		$Sprite2D.modulate = Color.WHITE

func fulfill():
	$FailureTimer.stop()
	fulfilled.emit()
	disappear()

func disappear():
	queue_free()

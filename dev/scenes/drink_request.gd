extends Area2D

signal fulfilled(tip: bool)
signal timed_out

var current_drink = null
var tip = true
var position3D = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$FailureProgressBar.value = $FailureTimer.time_left / $FailureTimer.wait_time


func _on_area_entered(area: Area2D):
	if area.is_in_group("Drinks"):
		current_drink = area
		area.add_request(self)
		
func _on_area_exited(area: Area2D):
	if area.is_in_group("Drinks"):
		current_drink = null
		area.remove_request(self)
		
func _on_failure_timer_timeout():
	timed_out.emit()
	disappear()

func _on_tip_timer_timeout():
	tip = false

func highlight_fulfillable(fulfillable: bool):
	if fulfillable:
		$Requestbubble.modulate = Color.YELLOW
	else:
		$Requestbubble.modulate = Color.WHITE

func fulfill():
	$FailureTimer.stop()
	#fulfilled.emit(tip)
	GameEvents.emit_signal("request_fulfilled", tip, position3D)
	disappear()

func disappear():
	if current_drink != null:
		current_drink.remove_request(self)
	queue_free()

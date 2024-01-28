extends Node3D

#@export var stats: Resource
var stats = null #stats are set on spawn

var performing = false
var waiting = true
var exiting = false
var entering = false
var to_target = Vector3.ZERO
var exiting_speed = 5.0
var in_hell = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$NameLabel.text = stats.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if exiting or entering:
		position += to_target * delta * exiting_speed


func _on_timer_timeout():
	if performing:
		var joke_quality = 0
		
		if randi_range(0, 100) > stats.bomb_chance:
			joke_quality = randi_range(stats.comedy / 5, stats.comedy)
			
			if randi_range(0, 100) < stats.hit_chance:
				joke_quality *= 2
		
		$Timer.wait_time = 4.0 + 4.0 * clamp(1.0 - (stats.endurance / 10.0), 0.0, 1.0)
		stats.endurance -= 1

		print("joke_quality: " + str(joke_quality))

		if joke_quality == 0:
			GameEvents.emit_signal("play_crickets")
			$Timer.wait_time = 9.0	# recovery time

		GameEvents.emit_signal("audience_react", joke_quality)


func pause_standup_stream(value):
	$StandupStream0.stream_paused = value
	$StandupStream1.stream_paused = value


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


func stop_performing():
	get_parent().current_comedian = self
	performing = false
	exiting = true
	$AnimationPlayer.stop()
	$StandupStream0.stop()
	$StandupStream1.stop()
	$Timer.stop()
	GameEvents.emit_signal("audience_idle")


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:

				if in_hell:
					# jump into pool
					# then show button next day
					match randi() % 4:
						0:
							$Scream0.play()
						1:
							$Scream1.play()
						2:
							$Scream2.play()
						3:
							$Scream3.play()
					GameEvents.emit_signal("comedian_judged")

				if waiting:
					print("GET ON THE STAGE!")
					waiting = false
					entering = true
					to_target = (get_parent().StagePosition.position - position).normalized()
					to_target.y = 0.0
					to_target = to_target.normalized()

				if performing:
					stop_performing()
					print("GET OFF THE STAGE!")
					to_target = (get_parent().ComedianExit.position - position)
					to_target.y = 0.0
					to_target = to_target.normalized()

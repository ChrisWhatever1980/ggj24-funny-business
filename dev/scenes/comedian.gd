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
var dying = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$NameLabel.text = stats.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if exiting or entering:
		position += to_target * delta * exiting_speed
	elif in_hell and dying:
		position += (to_target) * delta
		to_target += Vector3(0, -2.0, 0) * delta


func get_joke_quality():
	var joke_quality = 0
	if randi_range(0, 100) > stats.bomb_chance:
		joke_quality = randi_range(stats.comedy / 5, stats.comedy)

		if randi_range(0, 100) < stats.hit_chance:
			joke_quality *= 2

	return joke_quality


func _on_timer_timeout():
	if performing:
		var joke_quality = get_joke_quality()
		
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


func die():
	# jump into pool
	dying = true

	var pool_center = get_parent().get_node("Underworld/PoolCenter")
	to_target = (pool_center.global_position - global_position).normalized()
	to_target.y = 1.0

	match randi() % 4:
		0:
			$Scream0.play()
		1:
			$Scream1.play()
		2:
			$Scream2.play()
		3:
			$Scream3.play()

	# then show button next day
	GameEvents.emit_signal("comedian_judged")
	
	# this comedian is no longer available
	ComedianPool.dead.append(stats)


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:

				if in_hell:
					exiting = false
					entering = false
					performing = false
					waiting = false

					$StandupStream1.play()
					await get_tree().create_timer(3.0).timeout
					$StandupStream1.stop()

					# evaluate joke
					var devil_react = get_joke_quality() + randi_range(-2, 2)
					if devil_react <= 5:
						print("COMEDIAN FAILED")# comedian failed
						GameEvents.emit_signal("show_message", "TERRIBLE.")
						GameEvents.emit_signal("comedian_failed")
						die()
					else:
						print("COMEDIAN SUCCEEDED")
						GameEvents.emit_signal("show_message", "YOU AMUSE ME MORTAL. LEAVE.")
						GameEvents.emit_signal("comedian_judged")
						visible = false
				

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

extends RigidBody3D


var humor_modifier = 0
var max_amusement = 2
var min_amusement = -3
var tip_probability = 0.3
var throw_probability = 0.6
var thirsty_probability = 0.3
var mood = 0
var requesting_drink = false
var coming_in = true

var start_position = Vector3.ZERO
var target_position = Vector3.ZERO
var moving_in_timer = 0.0


var moods = [
	8,	#dead
	9,	#angry
	11,	#lame
	10,	#sad
	7,	#worst joke ever
	6,	#dont get it
	0,	#amused
	1,	#chuckle
	2,	#schadenfreude
	3,	#thats me
	4,	#good one
	5	#hilarious
]


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect_event("audience_react", self, "on_audience_react")
	GameEvents.connect_event("audience_idle", self, "on_audience_idle")
	humor_modifier = randi_range(-2, 2)
	$AnimationPlayer.seek($AnimationPlayer.current_animation_length * randf())

	set_mood(clamp(randi() % moods.size(), 0, moods.size() - 1))

	$Timer.wait_time = 5.0 + randf() * 10.0


func set_mood(_mood):
	$Node3D/Person/Sprite3D.frame = moods[_mood]


func on_audience_idle():
	$AnimationPlayer.seek($AnimationPlayer.current_animation_length * randf())
	$AnimationPlayer.play("idle_animation")


func on_audience_react(joke_quality):
	await get_tree().create_timer(randf()).timeout

	var guest_react = clamp(joke_quality + humor_modifier, 0, 11)

	if guest_react <= 5:
		match randi() % 5:
			0:
				$BooPlayer0.play()
			1:
				$BooPlayer1.play()
			2:
				$BooPlayer2.play()
			3:
				$BooPlayer3.play()
			4:
				$BooPlayer4.play()
	else:
		match randi() % 3:
			0:
				$AudioStreamPlayer3D.play()
			1:
				$AudioStreamPlayer3D2.play()
			1:
				$AudioStreamPlayer3D3.play()

	match guest_react:
		0:		# mood 8: dead
			# explode
			pass
		1:		# angry
			if randf() < throw_probability:
				GameEvents.emit_signal("spawn_tomato", position)
		2:		# lame
			if randf() < throw_probability:
				GameEvents.emit_signal("spawn_tomato", position)
			pass
		3:		# sad
			if randf() < throw_probability:
				GameEvents.emit_signal("spawn_tomato", position)
			pass
		4:		# worst joke ever
			if randf() < throw_probability:
				GameEvents.emit_signal("spawn_tomato", position)
			pass
		5:		# dont get it
			GameEvents.emit_signal("spawn_puddle", position)
			pass
		6:		# amused
			print("spawn_puddle")
			GameEvents.emit_signal("spawn_puddle", position)
			pass
		7:		# chuckle
			GameEvents.emit_signal("spawn_puddle", position)
			pass
		8:		# schadenfreude
			freeze = false
			apply_impulse(Vector3.UP * 0.4)
			pass
		9:		# thats me
			freeze = true
			$AnimationPlayer.play("laugh")
		10:		# good one
			GameEvents.emit_signal("spawn_puddle", position)
		11:		# hilarious
			freeze = false
			$AnimationPlayer.play("rofl_animation")

	set_mood(clamp(guest_react, 0, moods.size() - 1))

	if guest_react == max_amusement and randf() <= tip_probability:
		for c in range(0, randi_range(1, 2)):
			GameEvents.emit_signal("spawn_coin", position)

	if guest_react == min_amusement:
		queue_free()


func on_audience_rofl():
	await get_tree().create_timer(randf()).timeout
	freeze = false
	apply_impulse(Vector3.UP * 0.4)


func _process(delta):
	if get_parent().current_comedian:
		var to_comedian = get_parent().current_comedian.position - position
		to_comedian.y = 0.0
		look_at(position + to_comedian)
	
	if coming_in:
		if moving_in_timer < 1.0:
			position = lerp(start_position, target_position, moving_in_timer)
			moving_in_timer += delta * 0.2


func _on_timer_timeout():
	if !requesting_drink and randf() < thirsty_probability:
		await get_tree().create_timer(randf() * 10.0).timeout
		GameEvents.emit_signal("request_drink", position + Vector3.UP * 3)
		$Timer.wait_time = 5.0 + randf() * 10.0
		requesting_drink = true

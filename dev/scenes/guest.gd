extends RigidBody3D


var humor_modifier = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect_event("audience_react", self, "on_audience_react")
	humor_modifier = randi_range(-1, 1)


func on_audience_react(joke_quality):
	await get_tree().create_timer(randf()).timeout
	var guest_react = clamp(joke_quality + humor_modifier, 0, 3)
	match guest_react:
		0:	# gut-shaking laugh
			freeze = true
			$AnimationPlayer.play("laugh")
		1:	# jump up and drop
			freeze = false
			apply_impulse(Vector3.UP * 0.4)
		2:	#rofl
			freeze = false
			print("rofl")
			$AnimationPlayer.play("rofl")


func on_audience_rofl():
	await get_tree().create_timer(randf()).timeout
	freeze = false
	apply_impulse(Vector3.UP * 0.4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

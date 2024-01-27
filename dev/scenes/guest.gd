extends RigidBody3D


var Comedian = null


var humor_modifier = 0
var max_amusement = 2
var min_amusement = -3
var tip_probability = 0.3
var throw_probability = 0.6
var mood = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect_event("audience_react", self, "on_audience_react")
	humor_modifier = randi_range(-1, 1)


func set_mood(_mood):
	$Node3D/person/Sprite3D.frame = _mood



func on_audience_react(joke_quality):
	await get_tree().create_timer(randf()).timeout

	var guest_react = clamp(joke_quality + humor_modifier, -1, 3)
	
	match guest_react:
		-1:	# throw tomatoes
			if randf() < throw_probability:
				GameEvents.emit_signal("spawn_tomato", position)
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

	set_mood(clamp(guest_react + 1, 0, 4))

	if guest_react == max_amusement and randf() <= tip_probability:
		for c in range(0, randi_range(1, 2)):
			GameEvents.emit_signal("spawn_coin", position)
	
	if guest_react == min_amusement:
		queue_free()
		


func on_audience_rofl():
	await get_tree().create_timer(randf()).timeout
	freeze = false
	apply_impulse(Vector3.UP * 0.4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Comedian:
		var to_comedian = Comedian.position - position
		to_comedian.y = 0.0
		look_at(position + to_comedian)

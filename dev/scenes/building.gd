extends Node3D


@export var GuestScene:PackedScene
@export var CoinScene:PackedScene


var money = 0


func _ready():
	
	GameEvents.connect_event("spawn_coin", self, "on_spawn_coin")
	GameEvents.connect_event("increase_money", self, "on_increase_money")
	
	var pos = $comedy_club/FloorArea.position
	var size = $comedy_club/FloorArea/CollisionShape3D.shape.size
	var floor_rect = Rect2(pos.x - size.x / 2, pos.z - size.z / 2, size.x, size.z)
	print(str(floor_rect))
	
	var sampling = PoissonDiscSampling.new()
	var points = sampling.generate_2d_points(4.0, floor_rect, 5)
	print("Points: " + str(points.size()))
	var num_guests = points.size()
	for g in num_guests:
		var point = points.pick_random()
		var new_guest = GuestScene.instantiate()
		new_guest.position = Vector3(point.x, 1.0, point.y)
		new_guest.rotation.y = randf() * 2.0 * PI
		add_child(new_guest)
		points.erase(point)


func on_increase_money():
	money += 1
	match randi_range(0, 2):
		0:
			$MoneyEarnedAudio0.play()
		1:
			$MoneyEarnedAudio1.play()
		2:
			$MoneyEarnedAudio2.play()
	print("Money: " + str(money))


func on_spawn_coin(pos):
	var new_coin = CoinScene.instantiate()
	add_child(new_coin)
	new_coin.position = pos
	var rand_dir = Vector3(randf_range(-1, 1), 5.0, randf_range(-1, 1)) * 2.0
	new_coin.apply_impulse(rand_dir)


func _process(delta):
	pass


func _on_timer_timeout():
	var joke_quality = randi() % 3
	print("joke_quality: " + str(joke_quality))
	GameEvents.emit_signal("audience_react", joke_quality)

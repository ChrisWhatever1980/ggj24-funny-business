extends Node3D


@export var GuestScene:PackedScene
@export var CoinScene:PackedScene


@onready var ComedianExit = $comedy_club/ComedianExit
@onready var StagePosition = $StagePosition


@onready var ComedianWaitSlots = [
	$comedy_club/ComedianWait1,
	$comedy_club/ComedianWait2,
	$comedy_club/ComedianWait3,
	$comedy_club/ComedianWait4,
	$comedy_club/ComedianWait5
]


@onready var Comedian = $Comedian


var current_wait_slot = 0
var money = 0

var current_comedian = null


func _ready():

	GameEvents.connect_event("spawn_coin", self, "on_spawn_coin")
	GameEvents.connect_event("increase_money", self, "on_increase_money")
	GameEvents.connect_event("spawn_tomato", self, "on_spawn_tomato")
	GameEvents.connect_event("spawn_tomato_splat", self, "on_spawn_tomato_splat")

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
	
	for c in range(0, 5):
		spawn_comedian(c + 1)


func spawn_comedian(comedian_idx):
	var new_comedian = preload("res://scenes/comedian.tscn").instantiate()
	new_comedian.stats = load("res://resources/comedian_" + str(comedian_idx) + ".tres")
	new_comedian.position = ComedianWaitSlots[current_wait_slot].position
	current_wait_slot += 1
	add_child(new_comedian)


func on_spawn_tomato_splat(pos):
	var new_splat = preload("res://scenes/tomato_splat.tscn").instantiate()
	new_splat.position = pos
	print("splat")
	add_child(new_splat)


func on_spawn_tomato(pos):
	var new_tomato = preload("res://scenes/tomato.tscn").instantiate()
	add_child(new_tomato)
	new_tomato.position = pos
	var to_comedian = (Comedian.global_position - pos).normalized()
	var to_right = to_comedian.cross(Vector3.UP)
	new_tomato.apply_impulse(to_comedian * 10.0 + to_right * 0.2 * randf_range(-1, 1) + Vector3(0, 10.0,0))


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
	var joke_quality = 2#randi_range(-1, 2)
	print("joke_quality: " + str(joke_quality))
	GameEvents.emit_signal("audience_react", joke_quality)


func _on_exit_entered(area):
	# comedian entered exit
	
	print("Comedian has left the building")
	# save for post show evaluation


func _on_stage_entered(area):
	# comedian entered exit
	print("Comedian has climbed the stage")
	
	# save for post show evaluation
	var comedian = area.get_parent()
	comedian.begin_performance()

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


var current_wait_slot = 0
var money = 0
var in_the_club = true
var current_comedian = null


func _ready():

	GameEvents.connect_event("spawn_coin", self, "on_spawn_coin")
	GameEvents.connect_event("spawn_tomato", self, "on_spawn_tomato")
	GameEvents.connect_event("spawn_tomato_splat", self, "on_spawn_tomato_splat")
	GameEvents.connect_event("spawn_puddle", self, "on_spawn_puddle")
	GameEvents.connect_event("change_money", self, "on_change_money")

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


func on_spawn_puddle(pos):
	var new_puddle = preload("res://scenes/puddle.tscn").instantiate()
	new_puddle.position = pos
	print("puddle")
	add_child(new_puddle)


func on_spawn_tomato_splat(pos):
	var new_splat = preload("res://scenes/tomato_splat.tscn").instantiate()
	new_splat.position = pos
	print("splat")
	add_child(new_splat)


func on_spawn_tomato(pos):
	if current_comedian:
		var new_tomato = preload("res://scenes/tomato.tscn").instantiate()
		add_child(new_tomato)
		new_tomato.position = pos
		var to_comedian = (current_comedian.global_position - pos).normalized()
		var to_right = to_comedian.cross(Vector3.UP)
		new_tomato.apply_impulse(to_comedian * 10.0 + to_right * 0.2 * randf_range(-1, 1) + Vector3(0, 10.0,0))


func on_change_money(value):
	GameState.money = max(GameState.money + value, 0)
	match randi_range(0, 2):
		0:
			$MoneyEarnedAudio0.play()
		1:
			$MoneyEarnedAudio1.play()
		2:
			$MoneyEarnedAudio2.play()
			
	$AspectRatioContainer/HBoxContainer/MoneyAmount.text = str(GameState.money)
	print("Money: " + str(GameState.money))


func on_spawn_coin(pos):
	var new_coin = CoinScene.instantiate()
	add_child(new_coin)
	new_coin.position = pos
	var rand_dir = Vector3(randf_range(-1, 1), 5.0, randf_range(-1, 1)) * 2.0
	new_coin.apply_impulse(rand_dir)


func _process(delta):
	if in_the_club and Input.is_action_just_pressed("ui_down"):
		go_to_underworld()
	if !in_the_club and Input.is_action_just_pressed("ui_up"):
		go_to_club()
	
	pass


func _on_exit_entered(area):
	# comedian entered exit
	current_comedian = null
	print("Comedian has left the building")
	
	# save for post show evaluation


func _on_stage_entered(area):
	# comedian entered exit
	print("Comedian has climbed the stage")
	
	# save for post show evaluation
	current_comedian = area.get_parent()
	current_comedian.begin_performance()


func go_to_underworld():
	$AnimationPlayer.play("to_underworld")
	$BartenderMinigame.visible = false


func set_location(_upstairs):
	in_the_club = _upstairs
	print("In the club: " + str(in_the_club))
	$Underworld/AspectRatioContainer/Button.visible = !in_the_club


func go_to_club():
	$AnimationPlayer.play_backwards("to_underworld")
	$Underworld/AspectRatioContainer/Button.visible = false
	$BartenderMinigame.visible = true


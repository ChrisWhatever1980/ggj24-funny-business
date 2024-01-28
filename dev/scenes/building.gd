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
var in_the_club = true
var current_comedian = null
var floor_rect


func _ready():

	GameEvents.connect_event("spawn_coin", self, "on_spawn_coin")
	GameEvents.connect_event("spawn_tomato", self, "on_spawn_tomato")
	GameEvents.connect_event("spawn_tomato_splat", self, "on_spawn_tomato_splat")
	GameEvents.connect_event("spawn_puddle", self, "on_spawn_puddle")
	GameEvents.connect_event("change_money", self, "on_change_money")
	GameEvents.connect_event("start_show", self, "on_start_show")
	GameEvents.connect_event("start_game", self, "on_start_game")
	GameEvents.connect_event("comedian_judged", self, "on_comedian_judged")

	var pos = $comedy_club/FloorArea.position
	var size = $comedy_club/FloorArea/CollisionShape3D.shape.size
	floor_rect = Rect2(pos.x - size.x / 2, pos.z - size.z / 2, size.x, size.z)

	$AnimationPlayer.play_backwards("start_game_animation")


func on_start_game():
	$MainCamera.current = true
	$AspectRatioContainer/TitleScreen.visible = false
	$AspectRatioContainer.visible = true
	$MusicStreamPlayer.volume_db = -10.0
	$SpotLight.light_color = Color.WHITE
	$SpotLight2.light_color = Color.WHITE
	$BartenderMinigame.visible = true
	open_laptop()

func open_laptop():
	$Laptop/AnimationPlayer.play("open_animation")
	$Laptop/SubViewport/Node2D.open()
	

func on_start_show():
	var base = 5 + GameState.fame / 10
	var fame_today = randi_range(0, GameState.fame)
	var hype_today = randi_range(0, GameState.hype / 10)
	var comedian_bonus = 0
	
	for comedian in get_tree().get_nodes_in_group("Comedians"):
		comedian_bonus += randi_range(0, comedian.stats.fame)
	
	print("Spawn " + str(base)+ " base + " + str(fame_today) + " fame_today + " +str(comedian_bonus) + " comedian_bonus + " + str(hype_today) + " hype_today = " + str(base + fame_today + hype_today) + " Guests")
	generate_audience(base + comedian_bonus + fame_today + hype_today)
	$AnimationPlayer.play("laptop_to_main_animation")
	$AspectRatioContainer/EndShowButton.visible = true
	$BartenderMinigame.visible = true


func reset_day():
	current_comedian = null
	for comedian in get_tree().get_nodes_in_group("Comedians"):
		comedian.queue_free()

	for guest in get_tree().get_nodes_in_group("Guests"):
		guest.queue_free()

	$BartenderMinigame.visible = false
	$AspectRatioContainer/NextDayButton.visible = false

	$Laptop/SubViewport/Node2D.reset()
	$Laptop/SubViewport/Node2D/Container/VBoxContainer/TabContainer/Beverages.reset()
	$Laptop/SubViewport/Node2D/Container/VBoxContainer/TabContainer/Advertising.reset()

	go_to_club()
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play_backwards("laptop_to_main_animation")


func generate_audience(num_guests):
	var sampling = PoissonDiscSampling.new()
	var points = sampling.generate_2d_points(2.0, floor_rect, 5)
	print("Points: " + str(points.size()))
	num_guests = min(num_guests, points.size())
	for g in num_guests:
		await get_tree().create_timer(randf() * 0.1).timeout

		var point = points.pick_random()
		var new_guest = GuestScene.instantiate()
		new_guest.target_position = Vector3(point.x, 1.0, point.y)
		new_guest.start_position = $EntryPoint.position #new_guest.target_position + Vector3(point.x, 0.0, 25.0)
		new_guest.position = new_guest.start_position
		new_guest.rotation.y = randf() * 2.0 * PI
		add_child(new_guest)
		points.erase(point)


	for comedian_stats in ComedianPool.selected:
		spawn_comedian(comedian_stats)


func spawn_comedian(comedian_stats):
	var new_comedian = preload("res://scenes/comedian.tscn").instantiate()
	new_comedian.stats = comedian_stats
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
	if value > 0:
		match randi_range(0, 2):
			0:
				$MoneyEarnedAudio0.play()
			1:
				$MoneyEarnedAudio1.play()
			2:
				$MoneyEarnedAudio2.play()
	$AspectRatioContainer/HBoxContainer/MoneyAmount.text = str(GameState.money)
	$"Laptop/SubViewport/Node2D/Container/VBoxContainer/MarginContainer/HBoxContainer2/HBoxContainer/Budget#".text = "$" + str(GameState.money)


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
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()



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
	$AspectRatioContainer/EndShowButton.visible = false
	
	if current_comedian:
		current_comedian.stop_performing()
	
	# put up comedians for judgement
	var death_idx = 0
	for comedian in get_tree().get_nodes_in_group("Comedians"):
		print("Put comedian on plank!")
		comedian.to_target = Vector3.ZERO
		comedian.position = get_node("Underworld/comedian_plank/ComedianDeath" + str(death_idx)).global_position
		comedian.scale = Vector3.ONE * 0.25
		comedian.in_hell = true
		death_idx += 1


func set_location(_upstairs):
	in_the_club = _upstairs
	print("In the club: " + str(in_the_club))


func go_to_club():
	$AnimationPlayer.play_backwards("to_underworld")


func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var cam = $MainCamera
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * 10000
	var query = PhysicsRayQueryParameters3D.create(origin, end, 0b00000000_00000000_00001000_00000000, [$CoinVacuumer])
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if result:
		$CoinVacuumer.position = result.position


func _on_end_show_button_pressed():
	print("")
	go_to_underworld()


func _on_next_day_button_pressed():
	reset_day()


func on_comedian_judged():
	$AspectRatioContainer/NextDayButton.visible = true

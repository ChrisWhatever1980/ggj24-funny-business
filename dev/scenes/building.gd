extends Node3D

@export var GuestScene:PackedScene
@export var CoinScene:PackedScene
@export var MessageBoxScene: PackedScene


@onready var ComedianExit = $comedy_club/ComedianExit
@onready var StagePosition = $StagePosition


@onready var ComedianWaitSlots = [
	$comedy_club/ComedianWait1,
	$comedy_club/ComedianWait2,
	$comedy_club/ComedianWait3,
	$comedy_club/ComedianWait4,
	$comedy_club/ComedianWait5
]


var tutorial_finished = false
var current_wait_slot = 0
var in_the_club = true
var current_comedian = null
var floor_rect
var disappointed_the_devil = false


func _ready():

	GameEvents.connect_event("spawn_coin", self, "on_spawn_coin")
	GameEvents.connect_event("spawn_tomato", self, "on_spawn_tomato")
	GameEvents.connect_event("spawn_tomato_splat", self, "on_spawn_tomato_splat")
	GameEvents.connect_event("spawn_puddle", self, "on_spawn_puddle")
	GameEvents.connect_event("change_money", self, "on_change_money")
	GameEvents.connect_event("start_show", self, "on_start_show")
	GameEvents.connect_event("start_game", self, "on_start_game")
	GameEvents.connect_event("comedian_judged", self, "on_comedian_judged")
	GameEvents.connect_event("play_crickets", self, "on_play_crickets")
	GameEvents.connect_event("show_message", self, "on_show_message")

	var pos = $comedy_club/FloorArea.position
	var size = $comedy_club/FloorArea/CollisionShape3D.shape.size
	floor_rect = Rect2(pos.x - size.x / 2, pos.z - size.z / 2, size.x, size.z)

	$AnimationPlayer.play_backwards("start_game_animation")


func on_show_message(msg, duration = 5.0):
	var new_message = MessageBoxScene.instantiate()
	$AspectRatioContainer.add_child(new_message)
	new_message.set_message(msg, duration)


func on_start_game():
	$MainCamera/Camera3D.current = true
	$AspectRatioContainer/TitleScreen.visible = false
	$AspectRatioContainer.visible = true
	$MusicStreamPlayer.volume_db = -10.0
	$SpotLight.light_color = Color.WHITE
	$SpotLight2.light_color = Color.WHITE
	#$BartenderMinigame.visible = true
	$AspectRatioContainer/MoneyDisplay.visible = true
	$AspectRatioContainer/MoneyDisplay/MoneyDisplay/MoneyAmount.text = str(GameState.money)

	open_laptop()


func open_laptop():
	$Laptop/AnimationPlayer.play("open_animation")
	$Laptop/SubViewport/Node2D.open()

	if !tutorial_finished:
		on_show_message("Book comedians, set prices, buy beverages and place ads. When you are ready, click <Start Show>.")


func on_start_show():

	if !tutorial_finished:
		on_show_message("Click a comedian to get them on stage. Click a comedian on the stage if you want them to leave. Drag drinks to thirsty guests. Collect the coins with the mouse. Click <END SHOW>.", 8.0)
	
	for comedian_stats in ComedianPool.selected:
		spawn_comedian(comedian_stats)
	
	var price_malus = GameState.ticket_price + GameState.beer_price + GameState.wine_price / 2 + GameState.lemonade_price / 4
	var base = max(0, 5 + GameState.fame / 10 - price_malus / 10)
	var fame_today = max(0, randi_range(0, GameState.fame) - GameState.ticket_price) 
	var hype_today = max(0, randi_range(0, GameState.hype / 10) - GameState.ticket_price)
	print("Malus: "+ str(GameState.ticket_price)+ " ticket + "+ str(GameState.beer_price)+ " beer + "+ str(GameState.wine_price/2)+ " wine + "+ str(GameState.lemonade_price/4)+ " lemonade = "+ str(price_malus)+ " Malus")
	
	var comedian_bonus = 0
	for comedian in ComedianPool.selected:
		comedian_bonus += randi_range(0, comedian.fame)
	var guests = max(0, base + fame_today + hype_today + comedian_bonus)
	print("Audience " + str(base)+ " base + " + str(fame_today) + " fame_today + " + str(hype_today) + " hype_today + " +str(comedian_bonus) + " comedian_bonus = " + str(guests) + " Guests")
	generate_audience(guests)
	$AnimationPlayer.play("laptop_to_main_animation")
	$AspectRatioContainer/EndShowButton.visible = true
	$BartenderMinigame.visible = true
	
func spawn_comedian(comedian_stats):
	var new_comedian = preload("res://scenes/comedian.tscn").instantiate()
	new_comedian.stats = comedian_stats
	new_comedian.position = ComedianWaitSlots[current_wait_slot].position
	current_wait_slot += 1
	add_child(new_comedian)

func reset_day():
	current_comedian = null
	for comedian in get_tree().get_nodes_in_group("Comedians"):
		
		if comedian.stats.fame > GameState.fame / 10:
			GameState.fame += 0.1
		
		comedian.queue_free()
	
	var day_mood = 0
	for guest in get_tree().get_nodes_in_group("Guests"):
		day_mood += guest.mood
		guest.queue_free()
	
	GameState.fame += clampf(day_mood/100,-5,5)
	print("Last days mood: " + str(day_mood) + " changes fame by " + str(clampf(day_mood/100,-5,5)) + " -> " + str(GameState.fame) + " Fame")
	$AspectRatioContainer/MoneyDisplay.visible = true
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
	var count = 0
	print("Points: " + str(points.size()))
	num_guests = min(num_guests, points.size())
	for g in num_guests:
		await get_tree().create_timer(randf() * 0.1 + randi_range(0, count)/2).timeout
		count += 1
		var point = points.pick_random()
		var new_guest = GuestScene.instantiate()
		new_guest.target_position = Vector3(point.x, 1.0, point.y)
		new_guest.start_position = $EntryPoint.position #new_guest.target_position + Vector3(point.x, 0.0, 25.0)
		new_guest.position = new_guest.start_position
		new_guest.rotation.y = randf() * 2.0 * PI
		add_child(new_guest)
		points.erase(point)
		GameEvents.emit_signal("change_money", GameState.ticket_price)




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
	$AspectRatioContainer/MoneyDisplay/MoneyDisplay/MoneyAmount.text = str(GameState.money)
	$"Laptop/SubViewport/Node2D/Container/VBoxContainer/MarginContainer/HBoxContainer2/HBoxContainer/Budget#".text = "$" + str(GameState.money)


func on_spawn_coin(pos):
	var new_coin = CoinScene.instantiate()
	add_child(new_coin)
	new_coin.position = pos
	var rand_dir = Vector3(randf_range(-1, 1), 5.0, randf_range(-1, 1)) * 2.0
	new_coin.apply_impulse(rand_dir)


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_up"):
		GameEvents.emit_signal("screen_shake")



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
	$AspectRatioContainer/MoneyDisplay.visible = false

	if current_comedian:
		current_comedian.stop_performing()

	$EnterHellPlayer.play()

	if GameState.money >= 666:
		# The player has won against the devile
		await get_tree().create_timer(1.0).timeout
		GameEvents.emit_signal("screen_shake", 3.0)
		on_show_message("WHAT IS THIS. HOW CAN THAT BE. NOOOOOOOO.....", 3.0)
		GameEvents.emit_signal("comedian_judged")
		await get_tree().create_timer(2.0).timeout
		$GameOverScreen/YouWonLabel.visible = true
		$GameOverScreen/AnimationPlayer.play("game_over_animation")
	else:
	
		# put up comedians for judgement
		var comedians = get_tree().get_nodes_in_group("Comedians")

		if comedians.size() > 0:
			var death_idx = 0
			for comedian in get_tree().get_nodes_in_group("Comedians"):
				comedian.to_target = Vector3.ZERO
				comedian.position = get_node("Underworld/comedian_plank/ComedianDeath" + str(death_idx)).global_position
				comedian.scale = Vector3.ONE * 0.25
				comedian.in_hell = true
				death_idx += 1

			await get_tree().create_timer(1.0).timeout

			on_show_message("MAKE ME LAUGH AND I MIGHT SPARE YOUR SOUL, COMEDIAN.", 3.0)

			if !tutorial_finished:
				await get_tree().create_timer(4.0).timeout
				on_show_message("Which comedian should tell a joke to the devil? Click <NEXT DAY> when the deal is done.")
				tutorial_finished = true
		else:
			if !disappointed_the_devil:
				on_show_message("YOU DARE TO COME BEFORE ME WITHOUT SACRIFICE? DISAPPOINT ME AGAIN AND YOUR SOUL WILL BE FORFEIT!")
				disappointed_the_devil = true
			else:
				await get_tree().create_timer(1.0).timeout
				on_show_message("I WARNED YOU, MORTAL!")
				await get_tree().create_timer(1.0).timeout
				$GameOverScreen/YouLostLabel.visible = true
				$GameOverScreen/AnimationPlayer.play("game_over_animation")
			GameEvents.emit_signal("comedian_judged")


func set_location(_upstairs):
	in_the_club = _upstairs
	print("In the club: " + str(in_the_club))


func go_to_club():
	$AnimationPlayer.play_backwards("to_underworld")


func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var cam = $MainCamera/Camera3D
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


func on_play_crickets():
	if current_comedian:
		$MusicStreamPlayer.stream_paused = true
		current_comedian.pause_standup_stream(true)
		await get_tree().create_timer(2.0).timeout
		$CricketsPlayer.play()
		await get_tree().create_timer(2.0).timeout
		$MusicStreamPlayer.stream_paused = false
		current_comedian.pause_standup_stream(false)


func back_to_title():
	get_tree().reload_current_scene()

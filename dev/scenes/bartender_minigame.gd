extends Node2D

var beer_request = preload("res://scenes/beer_request.tscn")
var wine_request = preload("res://scenes/wine_request.tscn")
var lemonade_request = preload("res://scenes/lemonade_request.tscn")

signal update_fulfilled_requests(count: int)
signal update_tipped_requests(count: int)

var fulfilled_requests = 0
var tipped_requests = 0

var cam = null


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect_event("request_drink", self, "on_request_drink")
	GameEvents.connect_event("request_fulfilled", self, "_on_request_fulfilled")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func on_request_drink(pos3D):
	cam = get_viewport().get_camera_3d()
	if cam:
		var pos2D = cam.unproject_position(pos3D)
		spawn_request(pos2D, pos3D)


func _on_spawn_button_pressed():
	var x = randf_range(300, 800)
	var y = randf_range(100, 800)
	spawn_request(Vector2(x, y))
	#request.fulfilled.connect(_on_request_fulfilled)
	#GameEvents.connect_event("request_fulfilled")


func _on_request_fulfilled(tip, pos3D):

	if randi() % 2 == 0:
		$DrinkPlayer.play()
	else:
		$Drink0Player.play()

	var payment = 3
	
	fulfilled_requests += 1
	update_fulfilled_requests.emit(fulfilled_requests)

	if tip:
		payment += randi_range(1, 2)
		tipped_requests += 1
		update_tipped_requests.emit(tipped_requests)

	for p in payment:
		GameEvents.emit_signal("spawn_coin", pos3D)

func instantiate_random_request():
	var drink_type = DraggableBeer.DrinkType.values()[randi() % DraggableBeer.DrinkType.size()]
	match drink_type:
		DraggableBeer.DrinkType.BEER:
			return beer_request.instantiate()
		DraggableBeer.DrinkType.WINE:
			return wine_request.instantiate()
		DraggableBeer.DrinkType.LEMONADE:
			return lemonade_request.instantiate()
		_:
			return beer_request.instantiate()

func spawn_request(pos2D, pos3D=null):
	var request = instantiate_random_request()
	request.position = pos2D
	request.position3D = pos3D
	add_child(request)
	return request

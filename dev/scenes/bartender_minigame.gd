extends Node2D

signal update_fulfilled_requests(count: int)
signal update_tipped_requests(count: int)

var fulfilled_requests = 0
var tipped_requests = 0


var cam = null


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect_event("request_drink", self, "on_request_drink")
	GameEvents.connect_event("request_fulfilled", self, "_on_request_fulfilled")

	cam = get_viewport().get_camera_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	var cam = null


func on_request_drink(pos3D):
	if cam:
		var pos2D = cam.unproject_position(pos3D)
		$RequestSpawnArea.spawn_request(pos2D.x, pos2D.y, pos3D)


func _on_spawn_button_pressed():
	var x = randf_range(300, 800)
	var y = randf_range(100, 800)
	var request = $RequestSpawnArea.spawn_request(x, y)
	#request.fulfilled.connect(_on_request_fulfilled)
	#GameEvents.connect_event("request_fulfilled")


func _on_request_fulfilled(tip, pos3D):
	
	var payment = 3
	
	fulfilled_requests += 1
	update_fulfilled_requests.emit(fulfilled_requests)
	
	if tip:
		payment += randi_range(1, 2)
		tipped_requests += 1
		update_tipped_requests.emit(tipped_requests)

	for p in payment:
		GameEvents.emit_signal("spawn_coin", pos3D)

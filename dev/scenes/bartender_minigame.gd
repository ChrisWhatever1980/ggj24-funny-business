extends Node2D

signal update_fulfilled_requests(count: int)
signal update_tipped_requests(count: int)

var fulfilled_requests = 0
var tipped_requests = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_spawn_button_pressed():
	var x = randf_range(300, 800)
	var y = randf_range(100, 800)
	var request = $RequestSpawnArea.spawn_request(x, y)
	request.fulfilled.connect(_on_request_fulfilled)

func _on_request_fulfilled(tip):
	fulfilled_requests += 1
	update_fulfilled_requests.emit(fulfilled_requests)
	
	if tip:
		tipped_requests += 1
		update_tipped_requests.emit(tipped_requests)

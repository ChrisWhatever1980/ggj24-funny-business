extends Area2D

var fulfillable_requests = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		global_position = get_global_mouse_position()


func disappear():
	queue_free()

func add_request(request):
	if not fulfillable_requests.has(request):
		fulfillable_requests.append(request)
		
func remove_request(request):
	fulfillable_requests.erase(request)
	
func drop():
	var closest_request = null
	var smallest_square_distance = INF
	for request in fulfillable_requests:
		var difference = global_position - request.global_position
		var square_distance = difference.dot(difference)
		if square_distance < smallest_square_distance:
			smallest_square_distance = square_distance
			closest_request = request
	if closest_request != null:
		closest_request.fulfill()
	disappear()

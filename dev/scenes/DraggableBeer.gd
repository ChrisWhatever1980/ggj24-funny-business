extends Area2D

var fulfillable_requests = []
var smallest_square_distance = INF
var closest_request = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
	var res = find_closest_request()
	set_closest_request(res[0])
	smallest_square_distance = res[1]

func set_closest_request(request):
	if closest_request != null:
		closest_request.highlight_fulfillable(false)
	closest_request = request
	if closest_request != null:
		closest_request.highlight_fulfillable(true)

func find_closest_request():
	var new_closest_request = null
	var smallest_square_distance = INF
	for request in fulfillable_requests:
		var difference = global_position - request.global_position
		var square_distance = difference.dot(difference)
		if square_distance < smallest_square_distance:
			smallest_square_distance = square_distance
			new_closest_request = request
	return [new_closest_request, smallest_square_distance]

func disappear():
	queue_free()

func add_request(request):
	if not fulfillable_requests.has(request):
		fulfillable_requests.append(request)
		
func remove_request(request):
	fulfillable_requests.erase(request)
	if request == closest_request:
		request.highlight_fulfillable(false)
	
func drop():
	if closest_request != null:
		closest_request.fulfill()
	disappear()

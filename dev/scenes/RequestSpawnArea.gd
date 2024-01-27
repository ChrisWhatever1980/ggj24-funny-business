extends Area2D

var beer_request = preload("res://scenes/drink_request.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_request(x, y, pos3D=null):
	var request = beer_request.instantiate()
	request.position = Vector2(x, y)
	request.position3D = pos3D
	add_child(request)
	return request

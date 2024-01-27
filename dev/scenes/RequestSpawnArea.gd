extends Area2D

var beer_request = preload("res://drink_request.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_request(x, y):
	var request = beer_request.instantiate()
	request.position = Vector2(x, y)
	add_child(request)
	pass

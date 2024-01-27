extends Node2D


var grab_candidate = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_spawn_button_pressed():
	var x = randf_range(300, 1200)
	var y = randf_range(100, 1000)
	$RequestSpawnArea.spawn_request(x, y)

extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	# make a splat
	GameEvents.emit_signal("spawn_tomato_splat", position)


func _on_area_3d_body_entered(body):
	# make a splat
	GameEvents.emit_signal("spawn_tomato_splat", position)

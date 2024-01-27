extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				GameEvents.emit_signal("increase_money")
				$MeshInstance3D.visible = false
				$GPUParticles3D.emitting = true
				await get_tree().create_timer(1.0).timeout
				queue_free()

extends SpotLight3D


var target_position = Vector3.ZERO


func _process(delta):
	if get_parent().current_comedian:
		target_position = lerp(target_position, get_parent().current_comedian.global_position, delta * 2.0)
		look_at(target_position)

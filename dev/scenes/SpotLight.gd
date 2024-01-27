extends SpotLight3D


@export var Target:Node3D = null


var target_position = Vector3.ZERO


func _process(delta):
	if Target:
		target_position = lerp(target_position, Target.global_position, delta * 2.0)
		look_at(target_position)

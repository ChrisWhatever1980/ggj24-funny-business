extends Node3D


func _on_timer_timeout():
	var new_coin = preload("res://scenes/coin.tscn").instantiate()
	add_child(new_coin)
	new_coin.position = Vector3.ZERO
	var rand_dir = Vector3(randf_range(-1, 1), 5.0, randf_range(-1, 1)) * 2.0
	new_coin.apply_impulse(rand_dir)

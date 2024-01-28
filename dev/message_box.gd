extends PanelContainer


func set_message(msg, duration = 5.0):
	$MarginContainer/Label.text = msg
	$Timer.wait_time = duration
	$Timer.start()
	$AnimationPlayer.play("show_animation")


func _on_timer_timeout():
	$AnimationPlayer.play_backwards("show_animation")
	await get_tree().create_timer(0.5).timeout
	queue_free()

extends Node


signal audience_react
signal spawn_coin
signal change_money
signal spawn_tomato
signal spawn_tomato_splat
signal audience_idle
signal spawn_puddle
signal request_drink
signal request_fulfilled
signal start_show
signal start_game
signal comedian_judged


func connect_event(_signal: String, target: Object, method: String, binds: Array = [  ], flags: int = 0):
	var result
	if binds == []:
		result = super.connect(_signal, Callable(target, method), flags)
	else:
		result = super.connect(_signal, Callable(target, method).bindv(binds), flags)

	if result != OK:
		push_error("Cannot connect signal " + _signal + " to " + target.name + "." + method + "()")

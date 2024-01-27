extends Node


signal audience_react


func connect_event(_signal: String, target: Object, method: String, binds: Array = [  ], flags: int = 0):
	var result
	if binds == []:
		result = super.connect(_signal, Callable(target, method), flags)
	else:
		result = super.connect(_signal, Callable(target, method).bindv(binds), flags)

	if result != OK:
		push_error("Cannot connect signal " + _signal + " to " + target.name + "." + method + "()")

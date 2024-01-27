extends Button

var comedian
var parent

func _ready():
	parent = get_parent().get_parent().get_parent().get_parent().get_node("Stats")

func setup(c):
	comedian = c
	
func _on_button_up():
	print(comedian.name)
	parent.get_node("Name").text = comedian.name
	parent.get_node("Cost").text = "$" + str(comedian.cost)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

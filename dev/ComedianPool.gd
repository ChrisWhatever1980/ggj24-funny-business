extends Node

var pool = []
var selected = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.get_files_at("res://resources/comedians/")
	for path in dir:
		pool.append(load("res://resources/comedians/" + path))
	
	print("Loaded " + str(pool.size()) + " comedian stats")

func get_available_comedians( count : int ) -> Array:
	var selection_pool = pool.duplicate()
	var available = []
	var index = 0
	var emergencyCounter = 0
	
	while available.size() < count:
		index = randi_range( 0 , selection_pool.size() - 1 )
		available.append( selection_pool[index])
		selection_pool.remove_at( index )
		
		emergencyCounter += 1
		if emergencyCounter > 100:
			break
	
	print("Added " + str(available.size()) + " comedians")
	return available

func select_comedians(comedians:Array):
	reset_selection()
	selected = comedians

func reset_selection():
	selected.clear()

func select_comedian(comedian):
	selected.append(comedian)

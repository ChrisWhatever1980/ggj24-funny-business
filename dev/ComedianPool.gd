extends Node

var pool = []
var selected = []
var dead = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.get_files_at("res://resources/comedians/")
	for path in dir:
		pool.append(load("res://resources/comedians/" + path))
	
	print("Loaded " + str(pool.size()) + " comedian stats")


func get_available_comedians() -> Array:
	var selection_pool = pool.duplicate()
	var available = []
	var index = 0
	var emergencyCounter = 0
	var comedian
	var count = clamp(randi_range(1, 5) + randi_range(0, GameState.fame), 3, 10)
	
	while available.size() < count:
		index = randi_range( 0 , selection_pool.size() - 1 )
		comedian = selection_pool[index]
		
		if comedian.club_fame_requirement <= GameState.fame and comedian.availability >= randi_range(0,100):
			if !dead.has(selection_pool[index]):	# do not select dead comedians
				available.append( selection_pool[index] )
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

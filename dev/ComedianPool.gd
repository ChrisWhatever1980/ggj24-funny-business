extends Node

var pool = []
var selected = []
var dead = []

var comedians_resources = [
	"res://resources/comedians/comedian_1.tres",
	"res://resources/comedians/comedian_2.tres",
	"res://resources/comedians/comedian_3.tres",
	"res://resources/comedians/comedian_4.tres",
	"res://resources/comedians/comedian_5.tres",
	"res://resources/comedians/comedian_6.tres",
	"res://resources/comedians/comedian_7.tres",
	"res://resources/comedians/comedian_8.tres",
	"res://resources/comedians/comedian_9.tres",
	"res://resources/comedians/comedian_10.tres",
	"res://resources/comedians/comedian_11.tres",
	"res://resources/comedians/comedian_12.tres",
	"res://resources/comedians/comedian_13.tres",
	"res://resources/comedians/comedian_14.tres",
	"res://resources/comedians/comedian_15.tres"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pool.append(preload("res://resources/comedians/comedian_1.tres"))
	pool.append(preload("res://resources/comedians/comedian_2.tres"))
	pool.append(preload("res://resources/comedians/comedian_3.tres"))
	pool.append(preload("res://resources/comedians/comedian_4.tres"))
	pool.append(preload("res://resources/comedians/comedian_5.tres"))
	pool.append(preload("res://resources/comedians/comedian_6.tres"))
	pool.append(preload("res://resources/comedians/comedian_7.tres"))
	pool.append(preload("res://resources/comedians/comedian_8.tres"))
	pool.append(preload("res://resources/comedians/comedian_9.tres"))
	pool.append(preload("res://resources/comedians/comedian_10.tres"))
	pool.append(preload("res://resources/comedians/comedian_11.tres"))
	pool.append(preload("res://resources/comedians/comedian_12.tres"))
	pool.append(preload("res://resources/comedians/comedian_13.tres"))
	pool.append(preload("res://resources/comedians/comedian_14.tres"))
	pool.append(preload("res://resources/comedians/comedian_15.tres"))
	
	#var dir = DirAccess.get_files_at("res://resources/comedians/")
	#for path in comedians_resources:
		#pool.append(load("res://resources/comedians/" + path))
	
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

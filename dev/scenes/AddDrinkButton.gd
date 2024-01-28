extends Button

@export var drink_type: DraggableBeer.DrinkType = DraggableBeer.DrinkType.BEER

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	match drink_type:
		DraggableBeer.DrinkType.BEER:
			GameState.beer += 1
		DraggableBeer.DrinkType.WINE:
			GameState.wine += 1
		DraggableBeer.DrinkType.LEMONADE:
			GameState.lemonade += 1

extends Area2D

var hovering= false

var draggable_beer = preload("res://scenes/draggable_beer.tscn")
var draggable_wine = preload("res://scenes/draggable_wine.tscn")
var draggable_lemonade = preload("res://scenes/draggable_lemonade.tscn")

var dragging = false
var dragged_beer = null
var drink_count = 0

@export var drink_type: DraggableBeer.DrinkType = DraggableBeer.DrinkType.BEER

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_drink_count()
	
	if dragging and Input.is_action_just_released("click_left"):
		dragging = false
		dragged_beer.drop()
		dragged_beer = null
	
	if hovering and not dragging and drink_count > 0 and Input.is_action_just_pressed("click_left"):
		dragging = true
		spawn_beer()
		

func instantiate_drink():
	match drink_type:
		DraggableBeer.DrinkType.BEER:
			return draggable_beer.instantiate()
		DraggableBeer.DrinkType.WINE:
			return draggable_wine.instantiate()
		DraggableBeer.DrinkType.LEMONADE:
			return draggable_lemonade.instantiate()

func spawn_beer():
	var instance = instantiate_drink()
	dragged_beer = instance
	add_child(instance)

func _on_mouse_entered():
	hovering = true
	$Sprite2D.modulate = Color.LIGHT_GREEN
	
func _on_mouse_exited():
	hovering = false
	$Sprite2D.modulate = Color.WHITE

func update_drink_count():
	match drink_type:
		DraggableBeer.DrinkType.BEER:
			drink_count = GameState.beer
		DraggableBeer.DrinkType.WINE:
			drink_count = GameState.wine
		DraggableBeer.DrinkType.LEMONADE:
			drink_count = GameState.lemonade
			
	$Counter.text = str(drink_count)
	
	if drink_count <= 0:
		disable()
	else:
		enable()
		
func disable():
	$Sprite2D.modulate = Color.DIM_GRAY
	
func enable():
	$Sprite2D.modulate = Color.WHITE

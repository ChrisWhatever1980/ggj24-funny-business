extends Area2D

var hovering= false

var draggable_beer = preload("res://scenes/draggable_beer.tscn")
var dragging = false
var dragged_beer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging and Input.is_action_just_released("click_left"):
		dragging = false
		dragged_beer.disappear()
		dragged_beer = null
	
	if hovering and not dragging and Input.is_action_just_pressed("click_left"):
		dragging = true
		spawn_beer()

func spawn_beer():
	var instance = draggable_beer.instantiate()
	dragged_beer = instance
	add_child(instance)

func _on_mouse_entered():
	hovering = true
	$Sprite2D.modulate = Color.LIGHT_GREEN
	
func _on_mouse_exited():
	hovering = false
	$Sprite2D.modulate = Color.WHITE

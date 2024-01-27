extends ProgressBar

var stylebox = StyleBoxFlat.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_theme_stylebox_override("fill", stylebox)
	stylebox.bg_color = Color.GREEN
	stylebox.set_corner_radius_all(5)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tip_timer_timeout():
	stylebox.bg_color = Color.YELLOW

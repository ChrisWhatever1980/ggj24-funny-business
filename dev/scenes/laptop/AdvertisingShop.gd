extends VBoxContainer
@export var audio_ding : AudioStreamPlayer
@export var container : VBoxContainer

func _ready():
	var skip = true
	for box in container.get_children():
		if skip:
			skip = false
			continue
		setup_medium(box)
	reset()

func reset():
	GameState.hype = 0
	GameState.ads_placed = 0

func setup_medium(medium : HBoxContainer):
	var increase = medium.get_node("Buy/BuyButton")
	var decrease = medium.get_node("Buy/SellButton")
	var label = medium.get_node("Buy/BuyAmount")
	var reach = str_to_var(medium.get_node("Reach").text)
	var efficiency = str_to_var(medium.get_node("Efficiency").text)
	var price = str_to_var(medium.get_node("Price").text.replace("$",""))
	increase.button_up.connect(increase_hype.bind(reach, efficiency, price, label))
	decrease.button_up.connect(decrease_hype.bind(reach, efficiency, price, label))

func increase_hype(reach, efficiency, price, label):
	if GameState.money > price and str_to_var(label.text) < 10:
		GameEvents.emit_signal("change_money", -price)
		GameState.hype += reach * efficiency / 10
		label.text = str(str_to_var(label.text)+1)#
		GameState.ads_placed += 1
		print("Hype: " + str(GameState.hype))
	else:
		audio_ding.play()

func decrease_hype(reach, efficiency, price, label):
	if str_to_var(label.text) > 0:
		GameEvents.emit_signal("change_money", price)
		GameState.hype -= reach * efficiency / 10
		label.text = str(str_to_var(label.text)-1)
		GameState.ads_placed -= 1
		print("Hype: " + str(GameState.hype))
	else:
		audio_ding.play()

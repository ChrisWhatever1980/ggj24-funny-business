extends VBoxContainer
@export var buyBeer : Button
@export var sellBeer : Button
@export var increaseBeerPrice : Button
@export var decreaseBeerPrice : Button
@export var beerStock : Label
@export var beerBuy : Label
@export var beerPrice : Label

var beersAmount

# Called when the node enters the scene tree for the first time.
func _ready():
	buyBeer.button_up.connect(buy_beer)
	sellBeer.button_up.connect(sell_beer)
	increaseBeerPrice.button_up.connect(increase_beer_price)
	decreaseBeerPrice.button_up.connect(decrease_beer_price)
	reset()

func reset():
	beerStock.text = str(GameState.beer)
	beerBuy.text = "0"
	beerPrice.text = "$" + str(GameState.beer_price)
	beersAmount = 0

func buy_beer():
	if GameState.money > 0:
		GameEvents.emit_signal("change_money", -1)
		GameState.beer += 1
		beersAmount += 1
		beerBuy.text = str(beersAmount)

func sell_beer():
	if beersAmount > 0:
		GameEvents.emit_signal("change_money", 1)
		GameState.beer -= 1
		beersAmount -= 1
		beerBuy.text = str(beersAmount)

func increase_beer_price():
	if GameState.beer_price < 99:
		GameState.beer_price += 1
		beerPrice.text = "$" + str(GameState.beer_price)

func decrease_beer_price():
	if GameState.beer_price > 1:
		GameState.beer_price -= 1
		beerPrice.text = "$" + str(GameState.beer_price)

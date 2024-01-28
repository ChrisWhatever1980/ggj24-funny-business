extends VBoxContainer

@export var increaseBeerPrice : Button
@export var decreaseBeerPrice : Button
@export var beerPrice : Label

@export var increaseWinePrice : Button
@export var decreaseWinePrice : Button
@export var winePrice : Label

@export var increaseLemonadePrice : Button
@export var decreaseLemonadePrice : Button
@export var lemonadePrice : Label

@export var increaseTicketPrice : Button
@export var decreaseTicketPrice : Button
@export var ticketPrice : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	increaseBeerPrice.button_up.connect(increase_beer_price)
	decreaseBeerPrice.button_up.connect(decrease_beer_price)
	increaseWinePrice.button_up.connect(increase_wine_price)
	decreaseWinePrice.button_up.connect(decrease_wine_price)
	increaseLemonadePrice.button_up.connect(increase_lemonade_price)
	decreaseLemonadePrice.button_up.connect(decrease_lemonade_price)
	increaseTicketPrice.button_up.connect(increase_ticket_price)
	decreaseTicketPrice.button_up.connect(decrease_ticket_price)
	reset()

func reset():
	beerPrice.text = "$" + str(GameState.beer_price)
	winePrice.text = "$" + str(GameState.wine_price)
	lemonadePrice.text = "$" + str(GameState.lemonade_price)
	ticketPrice.text = "$" + str(GameState.ticket_price)

func increase_beer_price():
	if GameState.beer_price < 99:
		GameState.beer_price += 1
		beerPrice.text = "$" + str(GameState.beer_price)

func decrease_beer_price():
	if GameState.beer_price > 1:
		GameState.beer_price -= 1
		beerPrice.text = "$" + str(GameState.beer_price)

func increase_wine_price():
	if GameState.wine_price < 99:
		GameState.wine_price += 1
		winePrice.text = "$" + str(GameState.wine_price)

func decrease_wine_price():
	if GameState.wine_price > 1:
		GameState.wine_price -= 1
		winePrice.text = "$" + str(GameState.wine_price)

func increase_lemonade_price():
	if GameState.lemonade_price < 99:
		GameState.lemonade_price += 1
		lemonadePrice.text = "$" + str(GameState.lemonade_price)

func decrease_lemonade_price():
	if GameState.lemonade_price > 1:
		GameState.lemonade_price -= 1
		lemonadePrice.text = "$" + str(GameState.lemonade_price)
		
func increase_ticket_price():
	if GameState.ticket_price < 99:
		GameState.ticket_price += 1
		ticketPrice.text = "$" + str(GameState.ticket_price)

func decrease_ticket_price():
	if GameState.ticket_price > 0:
		GameState.ticket_price -= 1
		ticketPrice.text = "$" + str(GameState.ticket_price)

extends VBoxContainer
@export var audio_ding : AudioStreamPlayer

@export var buyBeer : Button
@export var sellBeer : Button
@export var beerStock : Label
@export var beerBuy : Label

@export var buyWine : Button
@export var sellWine : Button
@export var wineStock : Label
@export var wineBuy : Label

@export var buyLemonade : Button
@export var sellLemonade : Button
@export var lemonadeStock : Label
@export var lemonadeBuy : Label

var beersAmount
var wineAmount
var lemonadeAmount

func _ready():
	buyBeer.button_up.connect(buy_beer)
	sellBeer.button_up.connect(sell_beer)
	buyWine.button_up.connect(buy_wine)
	sellWine.button_up.connect(sell_wine)
	buyLemonade.button_up.connect(buy_lemonade)
	sellLemonade.button_up.connect(sell_lemonade)
	reset()

func reset():
	beerStock.text = str(GameState.beer)
	beerBuy.text = "0"
	beersAmount = 0
	wineStock.text = str(GameState.wine)
	wineBuy.text = "0"
	wineAmount = 0
	lemonadeStock.text = str(GameState.lemonade)
	lemonadeBuy.text = "0"
	lemonadeAmount = 0

func buy_beer():
	if GameState.money > 1:
		GameEvents.emit_signal("change_money", -2)
		GameState.beer += 1
		beersAmount += 1
		beerBuy.text = str(beersAmount)
		beerStock.text = str(GameState.beer)
	else:
		audio_ding.play()

func sell_beer():
	if beersAmount > 0:
		GameEvents.emit_signal("change_money", 2)
		GameState.beer -= 1
		beersAmount -= 1
		beerBuy.text = str(beersAmount)
		beerStock.text = str(GameState.beer)
	else:
		audio_ding.play()
		
func buy_wine():
	if GameState.money > 2:
		GameEvents.emit_signal("change_money", -3)
		GameState.wine += 1
		wineAmount += 1
		wineBuy.text = str(wineAmount)
		wineStock.text = str(GameState.wine)
	else:
		audio_ding.play()

func sell_wine():
	if wineAmount > 0:
		GameEvents.emit_signal("change_money", 3)
		GameState.wine -= 1
		wineAmount -= 1
		wineBuy.text = str(wineAmount)
		wineStock.text = str(GameState.wine)
	else:
		audio_ding.play()
		
func buy_lemonade():
	if GameState.money > 0:
		GameEvents.emit_signal("change_money", -1)
		GameState.lemonade += 1
		lemonadeAmount += 1
		lemonadeBuy.text = str(lemonadeAmount)
		lemonadeStock.text = str(GameState.lemonade)
	else:
		audio_ding.play()

func sell_lemonade():
	if lemonadeAmount > 0:
		GameEvents.emit_signal("change_money", 1)
		GameState.lemonade -= 1
		lemonadeAmount -= 1
		lemonadeBuy.text = str(lemonadeAmount)
		lemonadeStock.text = str(GameState.lemonade)
	else:
		audio_ding.play()

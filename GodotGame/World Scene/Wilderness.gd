extends Node2D

var signal_method = ""

@export var NumTwigs: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.visitedWilderness = true
	#TODO: Make inventory system into its own scene w/ graphics
	$UI/Inventory.text = "Inventory\nTwigs: " + str(NumTwigs)
	#SceneTransition.manual_fade.connect(go_to_next_day)
	$UI/Day.text = "Day " + str(GameData.day)
	var day = GameData.day
	if GameData.day > 10:
		day = 10

func increase_day(amount):
	if(GameData.day+amount > 0):
		GameData.day += amount

#**********TEST BUTTONS***********#
func _on_test_inc_1():
	print("+")
	increase_day(1)
	$UI/Day.text = "Day " + str(GameData.day)

func _on_test_dec_1():
	print("-")
	increase_day(-1)
	$UI/Day.text = "Day " + str(GameData.day)
	#vvv removes twig from inventory
	#Utils.remove_from_inventory("Twig", 1)
	Utils.remove_from_inventory("Rock", 1)
	print(GameData.inventory_amount)
#*********************************#

#********** INVENTORY ***********#
#func _on_twig_picked_up():
	#NumTwigs += 1
	#$UI/Inventory.text = "Inventory\nTwigs: " + str(NumTwigs)
	#GameData.twigItem += 1
#*********************************#

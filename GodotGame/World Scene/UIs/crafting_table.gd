extends Node2D

var enterBody = false

# Called when the node enters the scene tree for the first time.
var craftingList:Dictionary
var ItemOfTheDay
var itemImage
@onready var listText = [
	$UI/CraftingList/ItemList/ItemBox/Item,
	$UI/CraftingList/ItemList/ItemBox2/Item2,
	$UI/CraftingList/ItemList/ItemBox3/Item3,
	$UI/CraftingList/ItemList/ItemBox4/Item4
]
@onready var listTextNumber = [
	$UI/CraftingList/ItemList/ItemBox/Item/ItemText, 
	$UI/CraftingList/ItemList/ItemBox2/Item2/Item2Text,
	$UI/CraftingList/ItemList/ItemBox3/Item3/Item3Text,
	$UI/CraftingList/ItemList/ItemBox4/Item4/Item4Text
]
@onready var listTextImg = [
	$UI/CraftingList/ItemList/ItemBox/ItemImg, 
	$UI/CraftingList/ItemList/ItemBox2/ItemImg2,
	$UI/CraftingList/ItemList/ItemBox3/ItemImg3,
	$UI/CraftingList/ItemList/ItemBox4/ItemImg4
]
var listKeys
var listValues

#TODO Add crafting recipes
func _ready():
	$UI/CraftingList.visible = false
	if GameData.day == 2:
		craftingList = {"Twig": 6, "TinCan": 1}
		listKeys = craftingList.keys()
		listValues = craftingList.values()
		ItemOfTheDay = "BoilingPot"
		itemImage = load("res://Assets/Custom/Items/BoilingPot.png")
		pass
	elif GameData.day == 3:
		craftingList = {"WaterBottle": 1, "Sand": 2, "Rock": 2, "Moss": 2}
		listKeys = craftingList.keys()
		listValues = craftingList.values()
		ItemOfTheDay = "WaterFilter"
		itemImage = load("res://Assets/Custom/Items/WaterFilter.png")
		pass
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GameData.day != 1):
		#List of items needed in UI
		for i in range(0, len(craftingList)):
			listText[i].text = "" + str(listKeys[i])
			listTextNumber[i].text = "" + str(listValues[i])
			#add textures
			if listKeys[i] == "Twig":
				listTextImg[i].texture = load("res://Assets/Custom/Items/Twig.png")
			elif listKeys[i] == "TinCan":
				listTextImg[i].texture = load("res://Assets/Custom/Items/TinCan.png")
			elif listKeys[i] == "WaterBottle":
				listTextImg[i].texture = load("res://Assets/Custom/Items/WaterBottle.png")
			elif listKeys[i] == "Sand":
				listTextImg[i].texture = load("res://Assets/Custom/Items/Sand.png")
			elif listKeys[i] == "Rock":
				listTextImg[i].texture = load("res://Assets/Custom/Items/Rock.png")
			elif listKeys[i] == "Moss":
				listTextImg[i].texture = load("res://Assets/Custom/Items/Moss.png")
				
	else:
		$UI/CraftingList/CraftButton.visible = false
		
		
		
	if Input.is_action_just_pressed("StartDialogue") and enterBody == true:	
		if GameData.current_ui != "Crafting" && GameData.current_ui != "":
			return
		GameData.charLock = true
		GameData.current_ui = "Crafting"
		$UI/CraftingList.visible = true
		$PressInteraction.visible = false
		#Enable the crafting button if met
		listKeys = craftingList.keys()
		listValues = craftingList.values()
		var count = 0
		for i in range(0, len(listKeys)):
			if (GameData.inventory_amount.keys().find(listKeys[i]) != -1):
				if GameData.inventory_amount[listKeys[i]] >= craftingList[listKeys[i]]:
					count = count + 1
			
		if count == len(listKeys):
			$UI/CraftingList/CraftButton.disabled = false
		else:
			$UI/CraftingList/CraftButton.disabled = true
		

func _on_body_entered(body):
	if (body.name == "CharacterBody2D"):
		print("Entered crafting")
		$PressInteraction.visible = true
		$UI/CraftingList.visible = false
		enterBody = true
	pass # Replace with function body.


func _on_body_exited(body):
	if (body.name == "CharacterBody2D"):
		$PressInteraction.visible = false
		$UI/CraftingList.visible = false
		enterBody = false
		print("Exit crafting")
		GameData.current_ui = ""
	pass # Replace with function body.




func _on_craft_button_pressed():
		SoundControl.is_playing_sound("crafted")
		print("Crafted!")
		for i in range(0, len(listKeys)):
			Utils.remove_from_inventory(str(listKeys[i]), int(craftingList[listKeys[i]]))
		Utils.add_to_inventory(str(ItemOfTheDay), 1)
		$UI/CraftingList.visible = false
		
		$UI/CraftedItem.visible = true
		#TODO add what item the player made along with an image
		$UI/CraftedItem/ColorRect/ItemName.text = ItemOfTheDay
		$UI/CraftedItem/ColorRect/ItemImage.texture = itemImage




func _on_okay_button_pressed():
	$UI/CraftedItem.visible = false
	GameData.charLock = false
	GameData.current_ui = ""
	pass # Replace with function body.


func _on_x_button_pressed():
	$UI/CraftingList.visible = false
	GameData.charLock = false
	$PressInteraction.visible = true
	GameData.current_ui = ""
	pass # Replace with function body.
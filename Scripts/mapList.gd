extends Node

var currentMapIndex = -1

var maps = [
	"res://Scenes/Map_Scenes/map1.tscn",
	"res://Scenes/Map_Scenes/map2.tscn",
	"res://Scenes/Map_Scenes/map3.tscn",
	"res://Scenes/Map_Scenes/map4.tscn",
	"res://Scenes/Map_Scenes/map5.tscn",
	"res://Scenes/Map_Scenes/map6.tscn",
	"res://Scenes/Map_Scenes/map7.tscn",
	"res://Scenes/Map_Scenes/map8.tscn",
	"res://Scenes/Map_Scenes/map9.tscn",
	"res://Scenes/Map_Scenes/map10.tscn",
	"res://Scenes/Map_Scenes/map11.tscn",
	"res://Scenes/Map_Scenes/map12.tscn",
	"res://Scenes/Map_Scenes/map13.tscn",
	"res://Scenes/Map_Scenes/map14.tscn",
	"res://Scenes/Map_Scenes/map15.tscn",
	"res://Scenes/Map_Scenes/map16.tscn",
	"res://Scenes/Map_Scenes/map17.tscn",
	"res://Scenes/Map_Scenes/map18.tscn",
	"res://Scenes/Map_Scenes/map19.tscn",
	"res://Scenes/Map_Scenes/map20.tscn",

]

var models = [
	"CAR",
	"BOT",
	"BOT",
	"BOT",
	"CAR",
	"BOT",
	"BOT",
	"BOT",
	"CAR",
	"BOT",
	"BOT",
	"BOT",
	"CAR",
	"BOT",
	"BOT",
	"BOT",
	"CAR",
	"BOT",
	"BOT",
	"BOT",
]

var wander_model = [
	"CAR",
	"BOT",
	"BOT",
	"BOT",
	"CAR",
	"BOT",
	"BOT",
	"BOT",
	"CAR",
	"BOT",
	"BOT",
	"BOT",
	"CAR",
	"BOT",
	"BOT",
	"BOT",
	"CAR",
	"BOT",
	"BOT",
	"BOT"
]

func get_next_map():
	
	currentMapIndex = (currentMapIndex + 1) % maps.size()
	return maps[currentMapIndex]
	pass

func getBotModel():
	return models[getCurrentMap()]
	pass
	
func getWanderModel():
	return wander_model[getCurrentMap()]
	pass
	
func getCurrentMap():
	return currentMapIndex

func select_map(map: int):
	currentMapIndex = map - 1


func _ready() -> void:
	pass # Replace with function body


func _process(delta: float) -> void:
	pass

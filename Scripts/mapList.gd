extends Node

var currentMapIndex = -1

var maps = [
	"res://Scenes/Map_Scenes/map1.tscn",
	"res://Scenes/Map_Scenes/map2.tscn",
	"res://Scenes/Map_Scenes/map3.tscn",
	"res://Scenes/Map_Scenes/map4.tscn"
]

var models = [
	"BOT",
	"BOT",
	"BOT",
	"CAR"
]

var wander_model = [
	"BOT",
	"BOT",
	"BOT",
	"CAR"
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

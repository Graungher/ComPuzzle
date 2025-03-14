extends Node

var currentMapIndex = 1

var maps = [
	"res://Scenes/map1.tscn",
	"res://Scenes/ParentMap.tscn",
	
]


func get_next_map():
	currentMapIndex = (currentMapIndex + 1) % maps.size()
	return maps[currentMapIndex]
	pass


func select_map(map: int):
	return maps[map]


func _ready() -> void:
	pass # Replace with function body


func _process(delta: float) -> void:
	pass

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

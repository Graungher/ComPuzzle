extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_next_map():
	var next_map = "res://Scenes/map2.tscn"
	return next_map

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

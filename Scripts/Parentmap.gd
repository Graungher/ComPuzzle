extends TileMap

var start_tile = null
var end_tile = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_start_tile()


func _process(delta: float) -> void:
	pass


func find_start_tile():
	for cell in get_used_cells(1):
		var tile_data = get_cell_tile_data(1, cell)
		if tile_data and tile_data.get_custom_data("Start"):
			start_tile = cell
			#print("Start tile found at: ", start_tile)
			return
	#print("NO STARTING TILE")


func find_end_tile():
	for cell in get_used_cells(1):
		var tile_data = get_cell_tile_data(1, cell)
		if tile_data and tile_data.get_custom_data("Goal"):
			end_tile = cell
			#print("End tile found at: ", end_tile)
			return
	#print("NO STARTING TILE")


func get_start_tile():
	find_start_tile()
	return start_tile


func get_end_tile():
	find_end_tile()
	return end_tile

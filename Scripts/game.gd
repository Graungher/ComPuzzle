extends Node2D

@onready var robot = preload("res://Scenes/robot.tscn")
#@onready var robot = $Robot  # Reference to Robot
@onready var current_map = $TileMap  # Initial TileMap
@onready var cmdList = $ScrollContainer/Command_List
var spawn_position = null
var end_position = null
var theRobot
signal goAway


func _ready() -> void:
	mapSetup()
	spawnBot()
	pass


func switch_map():
	print("MAP CHANGE")
	if current_map:
		current_map.queue_free()  # Remove the old TileMap

	#robot.deleteRobot()
	emit_signal("goAway")
	var new_map_scene = load(mapList.get_next_map())  # Load scene
	var new_map = new_map_scene.instantiate()  # Create an instance
	add_child(new_map)
	move_child(new_map, 0)  # Ensure it’s the first child
	current_map = new_map  # Update reference

	await get_tree().process_frame  # Wait a frame to ensure it's added
	mapSetup()
	spawnBot()
	#robot.update_tilemap_reference()  # Make sure Robot gets the new TileMap

func get_current_map():
	return current_map


func spawnBot():
	if spawn_position:
		var bot_instance = robot.instantiate()
		bot_instance.global_position = spawn_position
		add_child(bot_instance)  # Add bot to scene
	
		cmdList.walk_signal.connect(bot_instance._walk)
		cmdList.turn_left_signal.connect(bot_instance._turnLeft)
		cmdList.turn_right_signal.connect(bot_instance._turnRight)
		goAway.connect(bot_instance.deleteRobot)
		bot_instance.connect("tookStep", checkGoal)
	
		theRobot = bot_instance
	pass

func show_error(err: String):
	#poppup.visible = true
	#if err == "NO END LOOP":
	#	errorLabel.text = "There is a loop without an 'END LOOP'"
	#else:
	#	errorLabel.text = ""
	#poppup.visible = true
	pass


func mapSetup():
	
	var defaultX = 50
	var defaultY = 25
	
	var tile_size = current_map.tile_set.tile_size.x
	var start_tile = current_map.get_start_tile()
	var end_tile = current_map.get_end_tile()
	spawn_position = current_map.map_to_local(start_tile) + Vector2(0,tile_size/2 - 3)
	end_position = current_map.map_to_local(end_tile) + Vector2(0,tile_size/2 - 3)
	
#	var tilemap_size = current_map.get_used_rect().size
#	var width_in_tiles = tilemap_size.x
#	var height_in_tiles = tilemap_size.y
	
#	var scaleX = float(defaultX) / float(width_in_tiles)
#	var scaleY = float(defaultY) / float(height_in_tiles)
	
#	current_map.scale = Vector2(scaleX, scaleY)
	
	
#	print("TileMap width (in tiles): ", width_in_tiles)
#	print("TileMap height (in tiles): ", height_in_tiles)
	
#	print("Scale X: ", scaleX, " Scale Y: ", scaleY)
	pass
	
func checkGoal():
	if theRobot.getCurrentPosition() == end_position:
		cmdList.clearList()
		switch_map()
	pass
	

func close_error() -> void:
	#poppup.visible = false
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	emit_signal("goAway")
	cmdList.fakeClearList()
	spawnBot()
	pass # Replace with function body.

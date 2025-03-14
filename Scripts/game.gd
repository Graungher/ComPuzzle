extends Node2D

@onready var robot = preload("res://Scenes/robot.tscn")
#@onready var robot = $Robot  # Reference to Robot
@onready var current_map = $TileMap  # Initial TileMap
@onready var cmdList = $ScrollContainer/Command_List
var spawn_position = null
var theRobot
var start_tile
var end_tile
var current_tile
var scaleX = 1
var scaleY = 1
signal goAway


func _ready() -> void:
	mapSetup()
	spawnBot()
	pass


func switch_map():
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
		bot_instance.connect("tookStep", botMoved)
	
		theRobot = bot_instance
		theRobot.SetMapStuff(scaleX, scaleY)
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
	start_tile = current_map.get_start_tile()
	current_tile = start_tile
	
	end_tile = current_map.get_end_tile()
	
	
	var tilemap_size = current_map.get_used_rect().size
	var width_in_tiles = tilemap_size.x
	var height_in_tiles = tilemap_size.y
	
	scaleX = float(defaultX) / float(width_in_tiles)
	scaleY = float(defaultY) / float(height_in_tiles)
	
	current_map.scale = Vector2(scaleX, scaleY)
	spawn_position = current_map.map_to_local(start_tile) + Vector2(0,tile_size/2 - 3)
	spawn_position *= current_map.scale
	
	print("TileMap width (in tiles): ", width_in_tiles)
	print("TileMap height (in tiles): ", height_in_tiles)
	
	print("Scale X: ", scaleX, " Scale Y: ", scaleY)
	pass


func botMoved():
	var compass = theRobot.getFacing()
	match compass:
		"north":
			current_tile += Vector2i(0,-1)
			pass
		"south":
			current_tile += Vector2i(0,1)
			pass
		"east":
			current_tile += Vector2i(1,0)
			pass
		"west":
			current_tile += Vector2i(-1,0)
			pass
	print(current_tile, " | ", end_tile)
	checkGoal()
	pass


func checkGoal():
	if current_tile == end_tile:
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


func _on_quit_button_pressed() -> void:
	get_tree().quit()

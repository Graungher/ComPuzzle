extends Node2D

@onready var bot = preload("res://Scenes/Characters/robot.tscn")
@onready var car = preload("res://Scenes/Characters/car.tscn")
@onready var current_map = $TileMap  # Initial TileMap
@onready var cmdList = $ScrollContainer/Command_List
@onready var errorWindow = $ErrorWindow
@onready var errorLabel = $ErrorWindow/Label
@onready var funcmaker = $FunctionMakerWindow
@onready var helper = $HelpWindow
@onready var victory = $Victory

var spawn_position = null
var robot
var theRobot
var start_tile
var end_tile
var current_tile
var scaleX = 1
var scaleY = 1


signal goAway
signal walk_signal

func _ready() -> void:
	switch_map()
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
	#robot.update_tilemap_reference()  # Make sure Robot gets the new TileMap


func get_current_map():
	return current_map


func spawnBot():
	if spawn_position:
		var bot_instance = robot.instantiate()
		add_child(bot_instance)  # Add bot to scene
		
	
		current_tile = start_tile
		walk_signal.connect(bot_instance._walk)
		cmdList.turn_left_signal.connect(bot_instance._turnLeft)
		cmdList.turn_right_signal.connect(bot_instance._turnRight)
		goAway.connect(bot_instance.deleteRobot)
	
		theRobot = bot_instance
		theRobot.SetMapStuff(scaleX, scaleY)
		bot_instance.global_position = spawn_position
		
	pass


func show_error(err: String):
	var error = 0
	if err == "NO END LOOP":
		errorLabel.text = "There is a loop without an 'END LOOP'!"
	elif err == "EXTRA END LOOP":
		errorLabel.text = "There are too many 'END LOOP's!"
	elif err == "LOOP NAN":
		errorLabel.text = "One of the loops had something that was not a number"
	elif err == "END BEFORE LOOP":
		errorLabel.text = "There is an End Loop with no open Loop"
	elif err == "OUTSIDE ELSE":
		errorLabel.text = "Else Needs to be inside the If and before the End If"
	elif err == "EXTRA ELSE":
		errorLabel.text = "There are too many elses in one IF"
	elif err == "END BEFORE IF":
		errorLabel.text = "There is an End If with no open If"
	elif err == "NO END IF":
		errorLabel.text = "There is an IF without an 'END IF'!"
		
	errorWindow.popup()
	pass


func mapSetup():
	
	var defaultX = 53
	var defaultY = 25
	
	var model = mapList.getBotModel()
	
	if model == "CAR":
		robot = car
	else:
		robot = bot
	
	
	var tile_size = current_map.tile_set.tile_size
	start_tile = current_map.get_start_tile()
	current_tile = start_tile
	
	end_tile = current_map.get_end_tile()
	
	var tilemap_size = current_map.get_used_rect().size
	var width_in_tiles = tilemap_size.x
	var height_in_tiles = tilemap_size.y
	
	scaleX = float(defaultX) / float(width_in_tiles)
	scaleY = float(defaultY) / float(height_in_tiles)
	
	current_map.scale = Vector2(scaleX, scaleY)
	
	spawn_position = current_map.map_to_local(start_tile)
	spawn_position += Vector2(0, tile_size.y / 2)
	
	spawn_position *= current_map.scale 
	spawnBot()
	
	cmdList.clearPeople() 
	for x in width_in_tiles:
		for y in height_in_tiles:
			var point = Vector2i(x,y)
			var tile = current_map.getTileType(point)
			if tile == "WanderSpawner":
				var spawn = current_map.map_to_local(point)
				spawn += Vector2(0, tile_size.y / 2)
				spawn *= current_map.scale 
				cmdList.createPeople(scaleX, scaleY, spawn, point)
				
	pass
	

func getNextTile():
	var next_tile: Vector2i
	var compass = theRobot.getFacing()
	match compass:
		"north":
			next_tile = current_tile + Vector2i(0,-1)
		"south":
			next_tile = current_tile + Vector2i(0,1)
		"east":
			next_tile = current_tile + Vector2i(1,0)
		"west":
			next_tile = current_tile + Vector2i(-1,0)
	return next_tile
	
func getCurrentTile():
	return current_tile

	
func gameGetTileType(next_tile: Vector2i):
	var tile_type = current_map.getTileType(next_tile)
	return tile_type
	
	
func botControl():
	var object
	var walkable = true
	
	var next_tile = getNextTile()
	var tile_type = gameGetTileType(next_tile)
	
	#print("CURRENT TILE: ", current_tile, "  | NEXT TILE", next_tile)
	var spots = cmdList.getLocationArray()
	
	for i in spots.size():
		if spots[i] == next_tile:
			walkable = false
	
	match tile_type:
		"Wall":
			walkable = false
			pass
		"Object":
			walkable = false
			pass
	if walkable:
		emit_signal("walk_signal")
		
		
		var upFeet = Vector2i (0,0)
		var sideFeet = Vector2i (0,1)
		var feet
		var compass = theRobot.getFacing()
		match compass:
			"north":
				feet = upFeet
			"south":
				feet = upFeet
			"east":
				feet = sideFeet
			"west":
				feet = sideFeet
		
		current_map.set_cell(2,current_tile,0,feet,0)
		await  wait_frames(15)
		current_map.set_cell(2,next_tile,0,feet,0)
		
		current_tile = next_tile
		pass
	pass

# waits 1 frame n times
func wait_frames(frame_count: int):
	# waits 1 fram frame_count times
	for i in range(frame_count):
		await get_tree().process_frame

func checkGoal():
	if current_tile == end_tile:
		cmdList.clearList()
		emit_signal("goAway")
		victory.show()
	else:
		emit_signal("goAway")
		spawnBot()



func _on_reset_button_pressed() -> void:
	emit_signal("goAway")
	cmdList.fakeClearList()
	spawnBot()
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_command_list_reset() -> void:
	current_tile = start_tile
	pass # Replace with function body.


func _on_make_a_func_pressed() -> void:
	funcmaker.popup()
	pass # Replace with function body.


func _on_help_pressed() -> void:
	helper.popup()
	pass # Replace with function body.


func Replay() -> void:
	cmdList.clearList()
	cmdList.fakeClearList()
	spawnBot()
	pass # Replace with function body.


func _on_command_list_runtime() -> void:
	current_map.clear_layer(2)
	pass # Replace with function body.

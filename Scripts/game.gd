extends Node2D

@onready var bot = preload("res://Scenes/Characters/robot.tscn")
@onready var car = preload("res://Scenes/Characters/car.tscn")
@onready var current_map = $TileMap  # Initial TileMap
@onready var cmdList = $ScrollContainer/Command_List
@onready var errorWindow = $ErrorWindow
@onready var errorLabel = $ErrorWindow/Label
@onready var funcmaker = $FunctionMakerWindow
@onready var funcselect = $FunctionSelector
@onready var helper = $HelpWindow
@onready var victory = $Victory
@onready var menu = $Panel

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
	else:
		errorLabel.text = "UNKNOWN ERROR"
	errorWindow.popup()
	pass

func mapSetup():
	
	var defaultX = 50
	var defaultY = 25
	var defaultTileSizeX = 32
	var defaultTileSizeY = 32
	
	var model = mapList.getBotModel()
	
	if model == "CAR":
		robot = car
	else:
		robot = bot
	
	
	
	var tile_size = current_map.tile_set.tile_size
	
	var tilescalex = float(defaultTileSizeX) / float(tile_size.x)
	var tilescaley = float(defaultTileSizeY) / float(tile_size.y)
	start_tile = current_map.get_start_tile()
	current_tile = start_tile
	
	end_tile = current_map.get_end_tile()
	
	var tilemap_size = current_map.get_used_rect().size
	var width_in_tiles = tilemap_size.x
	var height_in_tiles = tilemap_size.y
	
	scaleX = float(defaultX) / float(width_in_tiles)
	scaleY = float(defaultY) / float(height_in_tiles)
	
	current_map.scale = Vector2(scaleX, scaleY)
	current_map.scale *= Vector2(tilescalex, tilescaley)
	
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
		var moves = cmdList.getTotalMoves()
		var funcs = cmdList.getTotalFuncs()
		var lvl = mapList.getCurrentMap()
		if lvl == 20:
			get_tree().change_scene_to_file("res://Scenes/diploma.tscn")
		else:
			victory.setTotalInst(funcs)
			cmdList.clearList()
			emit_signal("goAway")
			victory.show()
			cmdList.clearPeople()
			var path = "user://UNLOCKED.txt"
			var current_value = mapList.getCurrentMap() + 1
			var stored_value = 0
			var file = FileAccess.open(path, FileAccess.READ)
			stored_value = int(file.get_line())
			file.close()
			if current_value >= stored_value:
				file = FileAccess.open(path, FileAccess.WRITE)
				file.store_line(str(mapList.getCurrentMap() + 2))
				file.close()
			var lines = []
			path = "user://BEST.txt"
			file = FileAccess.open(path, FileAccess.READ)
			while not file.eof_reached():
				lines.append(file.get_line())
			file.close()
			file = FileAccess.open(path, FileAccess.WRITE)
			var best = 21
			for i in 21:
				if i == (current_value - 1):
					if funcs < int(lines[i]):
						if funcs < best:
							best = funcs
							file.store_line(str(funcs))
						else:
							best = int(lines[i])
							file.store_line(lines[i])
					else:
						best = int(lines[i])
						file.store_line(lines[i])
				else:
					if lines[i] != "":
						file.store_line(lines[i])

			file.close()
			victory.setBest(best)
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
	funcselect.popup()
	pass # Replace with function body.


func _on_help_pressed() -> void:
	helper.popup()
	pass # Replace with function body.


func Replay() -> void:
	cmdList.clearList()
	cmdList.fakeClearList()
	mapSetup()
	pass # Replace with function body.


func _on_command_list_runtime() -> void:
	current_map.clear_layer(2)
	pass # Replace with function body.


func _on_function_selector_open_creator() -> void:
	funcmaker.popup()
	pass # Replace with function body.


func _on_function_maker_window_confirmed() -> void:
	pass # Replace with function body.


func _on_show_menu_pressed() -> void:
	menu.visible = not menu.visible
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	pass # Replace with function body.


func _on_select_map_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
	pass # Replace with function body.

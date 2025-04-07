extends Node2D

@onready var robot = preload("res://Scenes/Characters/robot.tscn")
@onready var current_map = $TileMap  # Initial TileMap
@onready var cmdList = $ScrollContainer/Command_List
@onready var errorWindow = $ErrorWindow
@onready var errorLabel = $ErrorPopup/Label
@onready var nameWindow = $FuncName
@onready var funcName = $FuncName/VBoxContainer/LineEdit
@onready var dispName = $FuncName/VBoxContainer/LineEdit2

var spawn_position = null
var theRobot
var start_tile
var end_tile
var current_tile
var next_tile
var scaleX = 1
var scaleY = 1
var customFuncName = "DEFAULT"
var displayName = "DEFAULT"

signal goAway
signal walk_signal
signal NAMECONFIRMED
signal SaveThis(customFuncName: String, displayName)
signal openSelect

func _ready() -> void:
	mapSetup()
	spawnBot()
	#get_parent().popup_hide_on_window_lose_focus = false
	pass


func spawnBot():
	if spawn_position:
		var bot_instance = robot.instantiate()
		bot_instance.global_position = spawn_position
		add_child(bot_instance)  # Add bot to scene
	
		current_tile = start_tile
		walk_signal.connect(bot_instance._walk)
		cmdList.turn_left_signal.connect(bot_instance._turnLeft)
		cmdList.turn_right_signal.connect(bot_instance._turnRight)
		goAway.connect(bot_instance.deleteRobot)
		bot_instance.connect("tookStep", botMoved)
	
		theRobot = bot_instance
		theRobot.SetMapStuff(scaleX, scaleY)
	pass


func show_error(err: String):
	var error = 0
	if err == "NO END LOOP":
		errorLabel.text = "There is a loop without an 'END LOOP'!"
	elif err == "EXTRA END LOOP":
		errorLabel.text = "There are too many 'END LOOP's!"
	elif err == "LOOP NAN":
		errorLabel.text = "One of the loops had something that was not a number"
	errorWindow.popup()
	pass


func mapSetup():
	
	var defaultX = 17
	var defaultY = 17
	
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
	spawn_position = current_map.map_to_local(start_tile)
	
	spawn_position = Vector2(289.0, 314)
	spawn_position *= current_map.scale 
	
	#spawn_position = current_map.map_to_local(start_tile) + Vector2(0,(tile_size/2) - int(3*scaleY))
	#spawn_position *= current_map.scale
	
	pass


func botMoved():
	var compass = theRobot.getFacing()
	match compass:
		"north":
			current_tile += Vector2i(0,-1)
		"south":
			current_tile += Vector2i(0,1)
		"east":
			current_tile += Vector2i(1,0)
		"west":
			current_tile += Vector2i(-1,0)
	#print("CURRENT TILE: ", current_tile, "  | GOAL TILE: ", end_tile)
	pass


func botControl():
	
	var compass = theRobot.getFacing()
	var object
	var walkable = true
	match compass:
		"north":
			next_tile = current_tile + Vector2i(0,-1)
		"south":
			next_tile = current_tile + Vector2i(0,1)
		"east":
			next_tile = current_tile + Vector2i(1,0)
		"west":
			next_tile = current_tile + Vector2i(-1,0)
	var tile_type = current_map.getTileType(next_tile)
	
	#print("CURRENT TILE: ", current_tile, "  | NEXT TILE", next_tile)
	
	match tile_type:
		"Wall":
			walkable = false
			pass
		"Object":
			walkable = false
			pass
	if walkable:
		emit_signal("walk_signal")
		current_tile = next_tile
		pass
	pass


func checkGoal():
	if current_tile == end_tile:
		cmdList.clearList()
	else:
		emit_signal("goAway")
		spawnBot()
		pass
	pass


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


func openNameWindow():
	nameWindow.popup()
	

func _on_func_name_confirmed() -> void:
	customFuncName = funcName.text
	displayName = dispName.text
	print("MAKER TEST")
	
	emit_signal("SaveThis", customFuncName, displayName)
	get_parent().hide()
	pass # Replace with function body.


func _on_function_maker_window_close_requested() -> void:
	get_parent().hide()
	pass # Replace with function body.

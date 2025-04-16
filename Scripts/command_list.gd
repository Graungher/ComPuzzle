extends VBoxContainer

@onready var student1 = preload("res://Scenes/Characters/Student1.tscn")
@onready var student2 = preload("res://Scenes/Characters/Student2.tscn")
@onready var student3 = preload("res://Scenes/Characters/Student3.tscn")
@onready var student4 = preload("res://Scenes/Characters/Student4.tscn")
@onready var car2 = preload("res://Scenes/Characters/car2.tscn")
@onready var car3 = preload("res://Scenes/Characters/car3.tscn")
@onready var car4 = preload("res://Scenes/Characters/car4.tscn")
@onready var car5 = preload("res://Scenes/Characters/car5.tscn")
@onready var WalkButton = preload("res://Scenes/Button_Scenes/button_walk.tscn")
@onready var LeftButton = preload("res://Scenes/Button_Scenes/button_left.tscn")
@onready var RightButton = preload("res://Scenes/Button_Scenes/button_right.tscn")
@onready var LoopButton = preload("res://Scenes/Button_Scenes/button_loop.tscn")
@onready var EndLoopButton = preload("res://Scenes/Button_Scenes/button_endloop.tscn")
@onready var EndIfButton = preload("res://Scenes/Button_Scenes/button_endif.tscn")
@onready var IfButton = preload("res://Scenes/Button_Scenes/button_if.tscn")
@onready var ElseButton = preload("res://Scenes/Button_Scenes/button_else.tscn")
@onready var CustButton = preload("res://Scenes/Button_Scenes/custom_button.tscn")

@onready var whiteLoop = "res://ComPuzzle Assets/buttons/LOOP/Loop_Button_White.png"
@onready var whiteIf = "res://ComPuzzle Assets/buttons/IF/If_Button_White.png"
@onready var whiteWalk = "res://ComPuzzle Assets/buttons/WALK/Walk_Button_White.png"
@onready var whiteLeft = "res://ComPuzzle Assets/buttons/TURNLEFT/Turn_Left_Button_White.png"
@onready var whiteRight = "res://ComPuzzle Assets/buttons/TURNRIGHT/Turn_Right_Button_White.png"

signal walk_signal
signal turn_left_signal
signal turn_right_signal
signal next_map
signal showError(err: String)
signal reset
signal checkGoal
signal runtime

var totalmoves = 0
var loopcounter = 0		# 0 if number of loops and endloops are equal
var ifcounter = 0		# 0 if number of ifs and endifs are equal
var framelen = 40		# number of frames to wait for animations
var cleared = false		# flag to stop the running of the command list
var running = false		# flag to disable things that interact with command list
var preLoaded = false
var innerLoop = 0
var scrollguy
var rootNode
var characters: Array[CharacterBody2D] = []
var char_spots: Array[Vector2i] = []
var funcName = ""
var dispName = ""
var total_moves = 0


#######################################
var GLOBAL_TRUE = false
#######################################

var tempArray = ["LEFT", "WALK", "WALK"]

# all nodes put into command list will have a label node that has the 
# type of node that it is

# once instantiated 
func _ready() -> void:
	scrollguy = get_parent()
	rootNode = get_tree().get_current_scene()
	#preloadCommands(tempArray)
	pass # Replace with function body.

# does something every frame
func _process(delta: float) -> void:
	pass

# moves the calling node up / down the list
func _on_texture_rect_mover(move: int, button: TextureButton):
	# if the command list is not being read
	if !running:
		# will get the node that called it, get that node's index, then move it
		# up or down depending on the button, then will call reindex 
		var Index = button.get_index()
		var newSpot = Index - move
		if Index == get_child_count() - 1 && move == -1:
			move_child(button, 0)
			reIndex()
		elif newSpot >= 0:
			move_child(button, newSpot)
			reIndex()

# replaces the index label on a node to its current index number
func reIndex():
	var index = 1;
	# starting at node 0, give them all their index based on order from top
	for child in get_children():
		if child.has_node("index_label"):
			child.get_node("index_label").text = str(index)
			index += 1

func getTotalMoves():
	return total_moves

func getTotalFuncs():
	return get_child_count()

# executes the command list in top down order
func realReadList():
	var the_name
	var i = 0
	var child
	var totals = get_child_count()
	# set running to true to disable the nodes that interact
	#  with the command list
	total_moves = 0
	running = true
	emit_signal("runtime")
	
	# i = index, totals = total children, cleared = quit out of reading the list
	while i < totals && !cleared:
		child = get_child(i)
		the_name = child.get_node("Label").text
		i += 1
		# waits for procrss node to finish, sends the label's text, the node
		# and the current index, then gets the new index number
		i = (await processNode(the_name, child, i))
		
	# after the loop, check to see if robot is on the goal
	emit_signal("checkGoal")
	# re-enable command list dependant nodes
	running = false
	pass

# handles node specialty or basic node functions for command list
func processNode(the_name: String, child: Node, i: int):
	# command list is imbedded in a scroll list calling the parent (scrollguy)
	# and using it's ensure control visible to make the nodes always be 
	# on the screen when executed
	scrollguy.ensure_control_visible(child)

	# if the node is a loop, then make run the loop func and make the node blue
	if the_name == "LOOP":
		# get the original texture then change it to a white version, then
		# apply a blue filter
		var reg = child.texture_normal
		child.texture_normal = load(whiteLoop)
		child.modulate = Color(0, .36, .85)
		
		#call the loop function
		i =  (await realLoop(child.get_index(), child))
		
		# make sure that there is still a child before resetting
		# (child may be gone if level reset before current action ended)
		if child:
			child.texture_normal = reg
			child.modulate = Color(1, 1, 1)
	
	# if the node is a loop, then make run the loop func and make the node blue
	elif the_name == "IF":
		# get the original texture then change it to a white version, then
		# apply a blue filter
		var reg = child.texture_normal
		child.texture_normal = load(whiteIf)
		child.get_node("condition").add_theme_color_override("font_color", Color.BLACK)
		child.modulate = Color(0, .36, .85)
		
		#call the if function
		i = (await ifNode(child.get_index(), child))
		
		# make sure that there is still a child before resetting
		# (child may be gone if level reset before current action ended)
		if child:
			child.get_node("condition").add_theme_color_override("font_color", Color.WHITE)
			child.texture_normal = reg
			child.modulate = Color(1, 1, 1)
	
	elif the_name == "CUSTOM":
		#await readFunctionList(tempArray)
		await readFunctionList(child.get_node("FuncName").text)
		#i += 1
		
	else:
		# call dofunc
		await doFunc(the_name, child)
		#i += 1

	return i

# does the function of basic nodes
func doFunc(the_name: String, child: Node):
	
	
	# apply green filter
	child.modulate = Color(.2588, .6275, 0)
	# switch based of label's text
	match the_name:
			"WALK":
				total_moves += 1
				if characters.size() > 0:
					movePeople()
				var reg = child.texture_normal
				child.texture_normal = load(whiteWalk)
				emit_signal("walk_signal")
				await wait_frames(framelen)
				if child:
					child.texture_normal = reg
			"LEFT":
				total_moves += 1
				if characters.size() > 0:
					movePeople()
				var reg = child.texture_normal
				child.texture_normal = load(whiteLeft)
				emit_signal("turn_left_signal")
				await wait_frames(framelen)
				if child:
					child.texture_normal = reg
			"RIGHT":
				total_moves += 1
				if characters.size() > 0:
					movePeople()
				var reg = child.texture_normal
				child.texture_normal = load(whiteRight)
				emit_signal("turn_right_signal")
				await wait_frames(framelen)
				if child:
					child.texture_normal = reg
	
	# make sure that there is still a child before resetting
	# (child may be gone if level reset before current action ended)
	if child:
		child.modulate = Color(1, 1, 1)
		
		

func commandLoops(commands: Array, index: int, count: int) -> int:
	var retspot = index  # Start return spot as the LOOP node
	var i = 0
	var body_start = index + 1 
	

	if count == 0:
		return findEndLoop(index)

	while i < count and !cleared:
		if cleared:
			return 0
		i += 1

		var currentIndex = body_start
		var the_name = ""
		
		while currentIndex < commands.size() and the_name != "ENDLOOP" and !cleared:
			the_name = commands[currentIndex]

			if the_name == "ENDLOOP":
				retspot = currentIndex + 1
				break
			else:
				# Await your async command processor
				currentIndex = await processCommands(the_name, commands, currentIndex)
				#currentIndex += 1

	return retspot

# loop will repeat all nodes between it and it's accociated end loop node
func realLoop(num: int, button: TextureButton):
	# num: the index of the loop node
	# button: the loop node itself (providing the "loopCount" text)
	var retspot = num 
	# Total number of loop iterations
	var totals = int(button.get_node("loopCount").text)
	# Used to keep track of how many loops left to player
	var loopsLeft = totals
	
	innerLoop += 1
	
	if !button.get_node("loopCount").text.is_valid_float():
		emit_signal("showError", "LOOP NAN")
	
	# The starting absolute index of the loop body is the node immediately after the loop node.
	var body_start = num + 1  
	var i = 0

	while i < totals and !cleared:
		if cleared:
			return 0

		i += 1
		loopsLeft -= 1
		
		# Start at the beginning of the loop body for every outer-loop iteration
		var currentIndex = body_start  
		var the_name = ""
		
		while the_name != "ENDLOOP" and !cleared:
			# Update the display so the player can see how many loops are left
			button.get_node("loopCount").text = str(loopsLeft)
			if cleared:
				return 0

			# Using absolute index for node access
			var child = get_child(currentIndex)
			the_name = child.get_node("Label").text
			
			if the_name == "ENDLOOP":
				retspot = currentIndex
				break
			else:
				# processNode now works with absolute indices.
				# We update currentIndex with the absolute index returned by processNode.
				currentIndex = await processNode(the_name, child, currentIndex) + 1
	
	if totals == 0:
		retspot = findEndLoop(num)
	
	if button:
		button.get_node("loopCount").text = str(totals)
	
	return retspot


# only used for loop = 0
func findEndLoop(num: int):
	var the_name = ""
	var i = 1
	var child
	var totLoop = 0
	var retspot = 1
	# finds the accociated endloop for an loop by keeping track of how many
	# nested loops there may be, then return the index of the correct end loop
	while (the_name != "ENDLOOP" || totLoop > 0) && !cleared:
		# gets node info
		child = get_child(num + i)
		the_name = child.get_node("Label").text
		i += 1
		# keeps track of nodes
		if the_name == "LOOP":
			totLoop += 1
		# found end if, then checks to see if totloop = 0. if 0 then correct end
		if the_name == "ENDLOOP":
			if totLoop == 0:
				retspot = child.get_index() + 1
			else: 
				the_name = ""
				totLoop -= 1
	return retspot
	pass

# can end the command list early and deletes all nodes
func clearList():
	# disables the running flag and enables the exit read flag
	running = false
	cleared = true
	
	#deletes children
	for child in get_children():
		child.queue_free()
		
	# waits an extra 5 frames than the anmiation	
	wait_frames(framelen+5)
	pass

# ends the command list early but does not clear it
func fakeClearList():
	# emit the reset signal, and end the reading of the command list early
	# BUT does not clear the list
	emit_signal("reset")
	running = false
	cleared = true
	
	# waits an extra 5 frames than the anmiation
	wait_frames(framelen+5)
	
	#resets the color filters
	for child in get_children():
		child.self_modulate = Color(1, 1, 1)
	pass

# makes sure that the loops and ifs are balanced before running
func validate():
	# diables the clear flag to allow the running of the commad list 
	cleared = false
	
	var i = get_child_count()
	var loops = 0
	var ifs = 0
	var endFlag = false
	var elseFlag = false
	var endBeforeLoop = false
	var extraElse = false
	var outElse = false
	var endBeforeif = false
	# if it is not already running, check if and loop counts
	if !running:
		for child in get_children():
			var the_name = child.get_node("Label").text
			if(the_name == "LOOP"):
				loops += 1
			elif(the_name == "ENDLOOP"):
				if loops == 0:
					endBeforeLoop = true
				else:
					loops -= 1
			elif(the_name == "IF"):
				ifs += 1
			elif(the_name == "ELSE"):
				if ifs > 0:
					if elseFlag:
						extraElse = true
					else:
						elseFlag = true
				else:
					outElse = true
				pass
			elif(the_name == "ENDIF"):
				elseFlag = false
				if ifs == 0:
					endBeforeif = true
				else:
					ifs -= 1
		if endBeforeLoop:
			emit_signal("showError", "END BEFORE LOOP")
		elif endBeforeif:
			emit_signal("showError", "END BEFORE IF")
		elif outElse:
			emit_signal("showError", "OUTSIDE ELSE")
		elif extraElse:
			emit_signal("showError", "EXTRA ELSE")
		elif(loops > 0):
			emit_signal("showError", "NO END LOOP")
		elif(loops < 0):
			emit_signal("showError", "EXTRA END LOOP")
		elif(ifs > 0):
			emit_signal("showError", "NO END IF")
		# if no errors, then start reading command list
		else:
			realReadList()

# waits 1 frame n times
func wait_frames(frame_count: int):
	# waits 1 fram frame_count times
	for i in range(frame_count):
		await get_tree().process_frame

# deletes a node from command list
func deleteNode(node: TextureButton):
	# only allow deletion of nodes if command list is not running
	if !running:
		# if there has to be a balance, change totals
		var the_name = node.get_node("Label").text
		if(the_name == "LOOP"):
			loopcounter -= 1
		elif(the_name == "ENDLOOP"):
			loopcounter += 1
		elif(the_name == "IF"):
			ifcounter -= 1
		elif(the_name == "ENDIF"):
			ifcounter += 1
		#delete node and wait 1 frame to update
		node.queue_free()
		await wait_frames(1)
		# call reindex to update index
		reIndex()
	pass

# creates a new node for the command list
func _on_make_node(the_name: String):
	# local variables
	var button_instance 
	var error = 0
	
	# if the list is not running, allow creation of new nodes
	if !running:
		match the_name:
			"WALK":
				button_instance = WalkButton.instantiate()
			"LEFT":
				button_instance = LeftButton.instantiate()
			"RIGHT":
				button_instance = RightButton.instantiate()
			"LOOP":
				loopcounter += 1
				button_instance = LoopButton.instantiate()
			"ENDLOOP":
				# allow or disable endloop creation based off balance
				if loopcounter > 0:
					loopcounter -= 1
					button_instance = EndLoopButton.instantiate()
				else:
					error += 1
					emit_signal("showError", "TOO MANY END LOOPS")
			"IF":
				ifcounter += 1
				button_instance = IfButton.instantiate()
			"ELSE":
				button_instance = ElseButton.instantiate()	
			"ENDIF":
				# allow or disable endif creation based off balance
				if ifcounter > 0:
					ifcounter -= 1
					button_instance = EndIfButton.instantiate()
				else:
					error += 1
					emit_signal("showError", "TOO MANY END LOOPS")
			"CUSTOM":
				button_instance = CustButton.instantiate()	
				
				pass
					
		# if no errors, then make the node, connect signals, and add to list
		if !error:
			add_child(button_instance)
			if button_instance.get_node("loopCount"):
				button_instance.get_node("loopCount").visible = true
			elif button_instance.get_node("FuncName"):
				button_instance.get_node("FuncName").text = funcName
				button_instance.get_node("Display_name").text = dispName
			button_instance.get_node("index_label").visible = true
			button_instance.get_node("index_label").text = str(get_child_count())
			button_instance.get_node("up_button").visible = true
			button_instance.get_node("down_button").visible = true
			button_instance.get_node("delete_button").visible = true
			button_instance.connect("deleteMe", deleteNode)
			button_instance.connect("mover", _on_texture_rect_mover)
		pass # Replace with function body.

# if will will do the nodes between if and else||endif if the condition is true
# will do nodes between else and endif (if else is present, otherwise nothing)
func ifNode(num: int, button: TextureButton):
	var the_name = ""
	var i = num + 1
	var child
	
	var elseTime = false
	var retSpot = num
	
	var condition = button.get_node("condition").text
	
	var isTrue = testCondition(condition)
	# does through the if's sections until endif then return the index
	while the_name != "ENDIF" && !cleared:
		# gets node info
		if cleared:
			return 0
		
		child = get_child(i)
		the_name = child.get_node("Label").text
		# else flag
		if the_name == "ELSE":
			elseTime = true
		elif the_name == "ENDIF":
			retSpot = child.get_index()
			break
		# 'then' section, if True and not at else yet
		if isTrue && !elseTime:
			# process node and get new index
			i = (await processNode(the_name, child, i))
		# if there is an else, then do the else stuff if flase
		elif !isTrue && elseTime: 
			# process node and get new index
			i = (await processNode(the_name, child, i))
		
		i += 1
	return retSpot


func testCondition(condition: String):
	var isTrue = false
	var tileData
	if condition == "WALL":
		var next_tile = rootNode.getNextTile()
		var object = rootNode. gameGetTileType(next_tile)
		if (object == "Wall") || (object == "Object"):
			isTrue = true
	elif condition == "EMPTY":
		isTrue = false
	elif condition == "PERSON":
		var charLoc = rootNode.getNextTile()
		for i in char_spots.size():
			if char_spots[i] == charLoc:
				isTrue = true
	return isTrue


func readFunctionList(file_name: String):
	var path = "user://%s.txt" % file_name
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var nickName = file.get_line()  # Reads the first line
		var line
		var commands: Array
		while not file.eof_reached():
			line = file.get_line()  # Reads the first line
			commands.append(line)
			print(line)
		await runCommands(commands)
		print("DONE")

func runCommands(commands: Array):
	var i = 0
	var TheCommand
	while i < commands.size():
		TheCommand = commands[i]	
		i = await processCommands(TheCommand, commands, i)
	pass

func processCommands(TheCommand: String, commands: Array, i: int):
	
	if TheCommand == "LOOP":
		var count = int(commands[i + 1])
		i+= 1
		i = (await commandLoops(commands, i, count))
		pass
	elif TheCommand == "IF":
		var cond = commands[i+1]
		i = await commandIf(commands, i, cond)
		pass
	else:
		await commandDo(TheCommand)
		i += 1
	return i

func commandDo(TheCommand: String):
	match TheCommand:
			"WALK":
				total_moves += 1
				print("walk")
				emit_signal("walk_signal")
				movePeople()
				await wait_frames(framelen)
			"LEFT":
				total_moves += 1
				print("left")
				emit_signal("turn_left_signal")
				movePeople()
				await wait_frames(framelen)
			"RIGHT":
				total_moves += 1
				print("right")
				emit_signal("turn_right_signal")
				movePeople()
				await wait_frames(framelen)
				
func commandIf(commands: Array, index: int, cond: String):
	var i = index + 1
	var elseTime = false
	var retSpot = index
	var TheCommand
	var condition = cond	
	var isTrue = testCondition(condition)
	
	# does through the if's sections until endif then return the index
	while TheCommand != "ENDIF" && !cleared:
		# gets node info
		if cleared:
			return 0
		
		TheCommand = commands[index + i]
		# else flag
		if TheCommand == "ELSE":
			elseTime = true
		elif TheCommand == "ENDIF":
			retSpot = index + i
			break
		# 'then' section, if True and not at else yet
		if isTrue && !elseTime:
			# process node and get new index
			i = (await processCommands(TheCommand, commands, i))
		# if there is an else, then do the else stuff if flase
		elif !isTrue && elseTime: 
			# process node and get new index
			i = (await processCommands(TheCommand, commands, i))
		else:
			i+= 1
	return retSpot
	




func preloadCommands(theWords: Array):
	if theWords.size() != 0:
		preLoaded = true
		for i in theWords:
			_on_make_node(i)
			pass
	pass


func _on_function_maker_nameconfirmed(saveName: String, dispName: String) -> void:
	var file = FileAccess.open("user://LIST.txt", FileAccess.READ_WRITE)
	while not file.eof_reached():
		var line = file.get_line()
		if line != saveName:
			file.seek_end()
			file.store_line(saveName)
			break
	file.close()
	
	file = FileAccess.open("user://%s.txt" % saveName, FileAccess.WRITE)
	var line
	
	line = dispName
	file.store_line(line)
	
	for child in get_children():
		line = child.get_node("Label").text
		if line == "LOOP":
			file.store_line(line)
			line = child.get_node("loopCount").text
		elif line == "IF":
			file.store_line(line)
			var condition = child.get_node("condition")
			var selected_text = condition.get_item_text(condition.get_selected())
			line = selected_text
		file.store_line(line)
		rootNode._on_make_a_func_pressed()
	


func _on_run_button_pressed33() -> void:
	readFunctionList("SAVEA")
	pass # Replace with function body.

func createPeople(scaleX: float, scaleY: float, spawn: Vector2, point: Vector2i):
	var student_variants = [student1, student2, student3, student4]
	var car_variants = [car2, car3, car4, car5]
	var character_instance
	var wandermodel = mapList.getWanderModel()
	if wandermodel == "CAR":
		var random_car = car_variants[randi() % car_variants.size()]
		character_instance = random_car.instantiate()

	else:
		var random_student = student_variants[randi() % student_variants.size()]
		character_instance = random_student.instantiate()

	character_instance.position = spawn
	
	var character_holder = rootNode.get_node("PeopleHolder")
	character_holder.add_child(character_instance)
	characters.append(character_instance)
	char_spots.append(point)
	character_instance.SetMapStuff(scaleX, scaleY)

func movePeople():
	for index in characters.size():
		var guy = characters[index]
		var r = randi_range(1, 5)
		match r:
			1:
				guy._turnRight()
				peopleWalker(guy, index)
			2:
				guy._turnLeft()
				peopleWalker(guy, index)
			3:
				guy._turnLeft()
				guy._turnLeft()
				peopleWalker(guy, index)
			4:
				peopleWalker(guy, index)
			5: 
				pass

func peopleWalker(guy: CharacterBody2D, index: int):
	var compass = guy.getFacing()
	var loc = char_spots[index]
	var new_tile
	var walkable = true
	match compass:
		"north":
			new_tile = loc + Vector2i(0,-1)
		"south":
			new_tile = loc + Vector2i(0,1)
		"east":
			new_tile = loc + Vector2i(1,0)
		"west":
			new_tile = loc + Vector2i(-1,0)
	var tile_type = rootNode.gameGetTileType(new_tile)
	
	match tile_type:
		"Wall":
			walkable = false
			pass
		"Object":
			walkable = false
			pass
		"Goal":
			walkable = false
			pass
	var charLoc = rootNode.getCurrentTile()
	for i in char_spots.size():
		if char_spots[i] == new_tile:
			walkable = false
		elif new_tile == charLoc:
			print("RAN PLAYER")
			walkable = false
	if walkable:
		char_spots[index] = new_tile
		guy._walk()
	pass

func clearPeople():
	for i in characters:
		i.queue_free()
	characters.clear()
	char_spots.clear()
		

func getLocationArray():
	return char_spots


func _on_function_selector_load_me(file_name: String) -> void:
	funcName = file_name
	var path = "user://%s.txt" % file_name
	var file = FileAccess.open(path, FileAccess.READ)
	dispName = file.get_line()  # Reads the first line
	if dispName.length() > 4:
		var break_index = 3
		for i in range(3):
			if dispName[i] == " ":
				break_index = i
				break

		var line1 = dispName.substr(0, break_index)
		var line2 = dispName.substr(break_index + 1) if dispName[break_index] == " " else dispName.substr(break_index)
		dispName = line1 + "-\n" + line2
	
	_on_make_node("CUSTOM")
	pass # Replace with function body.

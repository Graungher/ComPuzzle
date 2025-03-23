extends VBoxContainer

@onready var WalkButton = preload("res://Scenes/Button_Scenes/button_walk.tscn")
@onready var LeftButton = preload("res://Scenes/Button_Scenes/button_left.tscn")
@onready var RightButton = preload("res://Scenes/Button_Scenes/button_right.tscn")
@onready var LoopButton = preload("res://Scenes/Button_Scenes/button_loop.tscn")
@onready var EndLoopButton = preload("res://Scenes/Button_Scenes/button_endloop.tscn")
@onready var EndIfButton = preload("res://Scenes/Button_Scenes/button_endif.tscn")
@onready var IfButton = preload("res://Scenes/Button_Scenes/button_if.tscn")
@onready var ElseButton = preload("res://Scenes/Button_Scenes/button_else.tscn")

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

var totalmoves = 0
var loopcounter = 0		# 0 if number of loops and endloops are equal
var ifcounter = 0		# 0 if number of ifs and endifs are equal
var framelen = 40		# number of frames to wait for animations
var cleared = false		# flag to stop the running of the command list
var running = false		# flag to disable things that interact with command list
var preLoaded = false
var scrollguy


var tempArray = ["LEFT", "WALK", "WALK"]

# all nodes put into command list will have a label node that has the 
# type of node that it is

# once instantiated 
func _ready() -> void:
	scrollguy = get_parent()
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

# executes the command list in top down order
func realReadList():
	var the_name
	var i = 0
	var child
	var totals = get_child_count()
	# set running to true to disable the nodes that interact
	#  with the command list
	running = true
	
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
		child.modulate = Color(0, .36, .85)
		
		#call the if function
		i =  (await ifNode(child.get_index(), child))
		
		# make sure that there is still a child before resetting
		# (child may be gone if level reset before current action ended)
		if child:
			child.texture_normal = reg
			child.modulate = Color(1, 1, 1)
	
	elif the_name == "CUSTOM":
		await readFunctionList(tempArray)
		
	else:
		# call dofunc
		await doFunc(the_name, child)

	return i

# does the function of basic nodes
func doFunc(the_name: String, child: Node):
	# apply green filter
	child.modulate = Color(.2588, .6275, 0)
	# switch based of label's text
	match the_name:
			"WALK":
				var reg = child.texture_normal
				child.texture_normal = load(whiteWalk)
				emit_signal("walk_signal")
				await wait_frames(framelen)
				child.texture_normal = reg
			"LEFT":
				var reg = child.texture_normal
				child.texture_normal = load(whiteLeft)
				emit_signal("turn_left_signal")
				await wait_frames(framelen)
				child.texture_normal = reg
			"RIGHT":
				var reg = child.texture_normal
				child.texture_normal = load(whiteRight)
				emit_signal("turn_right_signal")
				await wait_frames(framelen)
				child.texture_normal = reg
	
	# make sure that there is still a child before resetting
	# (child may be gone if level reset before current action ended)
	if child:
		child.modulate = Color(1, 1, 1)

# loop will repeat all nodes between it and it's accociated end loop node
func realLoop(num: int, button: TextureButton):
	var the_name
	var i = 0
	var j = 1
	var retspot = num 
	var child
	var index
	var loopsLeft
	# total number of loops
	var totals = int(button.get_node("loopCount").text)
	# Used to keep track of how many loops left to player
	loopsLeft = totals
	# check for a number
	if !button.get_node("loopCount").text.is_valid_float():
		emit_signal("showError", "LOOP NAN")
		
	# i = number of loops executed, totals = total loop times
	# cleared is exit command list flag
	while i < totals && !cleared:
		# if cleared flag is true, return 0 to exit loop
		if cleared:
			return 0
		i += 1
		j = 0
		the_name = ""
		loopsLeft -= 1
		
		while the_name != "ENDLOOP" && !cleared:
			
			button.get_node("loopCount").text = str(loopsLeft)
			# if cleared flag is true, return 0 to exit loop
			if cleared:
				return 0
			
			# get next node info
			j += 1
			child = get_child(num + j)
			index = child.get_index()
			the_name = child.get_node("Label").text
			
			# exit loop and return index
			if the_name == "ENDLOOP":
				retspot = child.get_index()
				break
			# nested loop
			else: 
				j = (await processNode(the_name, child, j))
	if totals == 0:
		retspot = findEndLoop(num)
	# reset the label
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
	# if it is not already running, check if and loop counts
	if !running:
		for child in get_children():
			var the_name = child.get_node("Label").text
			if(the_name == "LOOP"):
				loops += 1
			if(the_name == "ENDLOOP"):
				loops -= 1
		if(loops > 0):
			emit_signal("showError", "NO END LOOP")
		elif(loops < 0):
			emit_signal("showError", "EXTRA END LOOP")
			
		# if no errors, then start reading command list
		else:
			realReadList()
			#_read_list()

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
					
		# if no errors, then make the node, connect signals, and add to list
		if !error:
			add_child(button_instance)
			if button_instance.get_node("loopCount"):
				button_instance.get_node("loopCount").visible = true
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
	var isTrue = true
	var elseTime = false
	var retSpot = num
	
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


func readFunctionList(theWords: Array):
	
	#for i in theWords:
	#	await doFunc(i)
	pass


func preloadCommands(theWords: Array):
	if theWords.size() != 0:
		preLoaded = true
		for i in theWords:
			_on_make_node(i)
			pass
	pass

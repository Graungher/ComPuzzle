extends VBoxContainer

@onready var WalkButton = preload("res://Scenes/button_walk.tscn")
@onready var LeftButton = preload("res://Scenes/button_left.tscn")
@onready var RightButton = preload("res://Scenes/button_right.tscn")
@onready var LoopButton = preload("res://Scenes/button_loop.tscn")
@onready var EndLoopButton = preload("res://Scenes/button_endloop.tscn")

signal walk_signal
signal turn_left_signal
signal turn_right_signal
signal next_map
signal showError(err: String)
var totalmoves = 0
var loopcounter = 0
var framelen = 40
var cleared = false
var running = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_rect_mover(move: int, button: TextureButton):
	if !running:
		var Index = button.get_index()
		var newSpot = Index - move
		move_child(button, newSpot)
		reIndex()


func _read_list():
	var the_name
	var i = 0
	var child
	var totals = get_child_count()
	emit_signal("showError", "NO ERROR")
	running = true
	while i < totals && !cleared:
		child = get_child(i)
		the_name = child.get_node("Label").text
		
		if the_name == "LOOP":
			i =  (await realLoop(child.get_index(), child) - 1)
		else:
			await doFunc(the_name)
		i += 1
	running = false
	pass


func doFunc(the_name: String):
	match the_name:
			"WALK":
				print("WALK EMITTED")
				emit_signal("walk_signal")
				await wait_frames(framelen)
			"LEFT":
				totalmoves += 1
				emit_signal("turn_left_signal")
				await wait_frames(framelen)
			"RIGHT":
				emit_signal("turn_right_signal")
				await wait_frames(framelen)


func realLoop(num: int, button: TextureButton):
	var the_name
	var i = 0
	var j = 1
	var retspot = num 
	var child
	var index
	var totals = int(button.get_node("loopCount").text)
	var goLoop = true
	if totals == 0:
		goLoop = false
	while i < totals && !cleared:
		if cleared:
			return 0
		i += 1
		j = 0
		the_name = ""
		while the_name != "ENDLOOP" && !cleared:
			if cleared:
				return 0
			j += 1
			child = get_child(num + j)
			index = child.get_index()
			the_name = child.get_node("Label").text
			
			if the_name == "ENDLOOP":
				retspot = child.get_index()
				break
			elif the_name == "LOOP":
				var loop_return = await realLoop(child.get_index(), child)
				j = loop_return - num  # Adjust j based on where the loop ended	
			else: 
				await doFunc(the_name)
	if totals == 0:
		retspot = findEndLoop(num) # index then loop from here?
	return retspot
	
func findEndLoop(num: int):
	var the_name = ""
	var i = 1
	var child
	var totLoop = 0
	var retspot = 1
	while (the_name != "ENDLOOP" || totLoop > 0) && !cleared:
		child = get_child(num + i)
		the_name = child.get_node("Label").text
		i += 1
		if the_name == "LOOP":
			totLoop += 1
		if the_name == "ENDLOOP":
			if totLoop == 0:
				retspot = child.get_index() + 1
			else: 
				the_name = ""
				totLoop -= 1
	return retspot
	pass
	
func clearList():
	running = false
	for child in get_children():
		child.queue_free()
	cleared = true
	wait_frames(framelen+5)
	pass

func fakeClearList():
	running = false
	cleared = true
	wait_frames(framelen+5)
	pass
	
func validate():
	cleared = false
	var i = get_child_count()
	var loops = 0
	var error = 0;
	
	for child in get_children():
		var the_name = child.get_node("Label").text
		if(the_name == "LOOP"):
			loops += 1
		if(the_name == "ENDLOOP"):
			loops -= 1
	if(loops != 0 || error):
		emit_signal("showError", "NO END LOOP")
	else:
		_read_list()

func wait_frames(frame_count: int):
	for i in range(frame_count):
		await get_tree().process_frame



func deleteNode(node: TextureButton):
	if !running:
		var the_name = node.get_node("Label").text
		if(the_name == "LOOP"):
			loopcounter -= 1
		if(the_name == "ENDLOOP"):
			loopcounter += 1
		node.queue_free()
		await wait_frames(1)
		reIndex()
	pass

func reIndex():
	var index = 1;
	for child in get_children():
		if child.has_node("index_label"):
			child.get_node("index_label").text = str(index)
			index += 1
			

func _on_make_node(the_name: String):
	var button_instance 
	var error = 0
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
				if loopcounter > 0:
					loopcounter -= 1
					button_instance = EndLoopButton.instantiate()
				else:
					error += 1
					emit_signal("showError", "TOO MANY END LOOPS")
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

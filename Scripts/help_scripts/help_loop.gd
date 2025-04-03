extends AcceptDialog

@onready var whiteLoop = "res://ComPuzzle Assets/buttons/LOOP/Loop_Button_White.png"
@onready var whiteWalk = "res://ComPuzzle Assets/buttons/WALK/Walk_Button_White.png"
@onready var whiteLeft = "res://ComPuzzle Assets/buttons/TURNLEFT/Turn_Left_Button_White.png" 
@onready var robot = $Node2D/Robot
@onready var list = $Node2D/VBoxContainer
@onready var label = $Node2D/Label2

var spawnSpot = Vector2(301.0,332.0)
var framelen = 40
signal LEFT
signal WALK
signal Gone

func _on_confirmed() -> void:
	var total = 4
	var i = 0
	var loop = list.get_child(0)
	var reg = loop.texture_normal
	loop.texture_normal = load(whiteLoop)
	loop.modulate = Color(0, .36, .85)
	while i < total:
		i += 1
		label.text = str(total - i)
		await process(list.get_child(1), 1)
		await process(list.get_child(2), 0)
		pass
	loop.modulate = Color(1,1,1)
	loop.texture_normal = reg
		
func process(child: Node, type: int):
	child.modulate = Color(.2588, .6275, 0)
	if type == 1:
		var reg = child.texture_normal
		child.texture_normal = load(whiteWalk)
		emit_signal("WALK")
		await wait_frames(framelen)
		if child:
			child.texture_normal = reg
	else:
		var reg = child.texture_normal
		child.texture_normal = load(whiteLeft)
		emit_signal("LEFT")
		await wait_frames(framelen)
		if child:
			child.texture_normal = reg
	child.modulate = Color(1, 1, 1)
	pass
	

func resetBot():
	emit_signal("LEFT")
	pass
	
func wait_frames(frame_count: int) -> void:
	for i in frame_count:
		await get_tree().process_frame


func _on_canceled() -> void:
	emit_signal("Gone")
	self.queue_free()
	pass # Replace with function body.

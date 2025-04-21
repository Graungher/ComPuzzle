extends AcceptDialog

@onready var whiteWalk = "res://ComPuzzle Assets/buttons/WALK/Walk_Button_White.png"
@onready var whiteLeft = "res://ComPuzzle Assets/buttons/TURNLEFT/Turn_Left_Button_White.png"
@onready var whiteLoop = "res://ComPuzzle Assets/buttons/LOOP/Loop_Button_White.png"
@onready var whiteIf = "res://ComPuzzle Assets/buttons/IF/If_Button_White.png"
@onready var baseLoop = "res://ComPuzzle Assets/buttons/LOOP/Loop_Button.png"
@onready var baseIf = "res://ComPuzzle Assets/buttons/IF/If_Button.png"
@onready var walkpng = $Node2D/VBoxContainer/TextureRect5
@onready var leftpng = $Node2D/VBoxContainer/TextureRect3
@onready var robot = $Node2D/Robot
@onready var loopie = $Node2D/VBoxContainer/TextureRect2
@onready var iffie = $Node2D/VBoxContainer/TextureRect6
@onready var looplabel = $Node2D/Label2
@onready var iflabel = $Node2D/Label3

var spawnSpot = Vector2(301.0,332.0)
signal LEFT
signal RIGHT
signal walk
signal Gone

func _on_confirmed() -> void:
	
	loopie.modulate = Color(0, .36, .85)
	loopie.texture = load(whiteLoop)
	
	iffie.modulate = Color(0, .36, .85)
	iffie.texture = load(whiteIf)
	
	emit_signal("walk")
	looplabel.text = "2"
	var reg = walkpng.texture
	walkpng.modulate = Color(.2588, .6275, 0)
	walkpng.texture = load(whiteWalk)
	await wait_frames(40)
	walkpng.modulate = Color(1,1,1)
	walkpng.texture = reg
	
	
	emit_signal("LEFT")
	looplabel.text = "1"
	reg = leftpng.texture
	leftpng.texture = load(whiteLeft)
	leftpng.modulate = Color(.2588, .6275, 0)
	await wait_frames(40)
	leftpng.modulate = Color(1, 1, 1)
	leftpng.texture = reg
	
	emit_signal("walk")
	looplabel.text = "0"
	reg = walkpng.texture
	walkpng.modulate = Color(.2588, .6275, 0)
	walkpng.texture = load(whiteWalk)
	await wait_frames(40)
	walkpng.modulate = Color(1,1,1)
	walkpng.texture = reg
	looplabel.text = "3"
	
	loopie.modulate = Color(1,1,1)
	loopie.texture = load(baseLoop)
	
	iffie.modulate = Color(1,1,1)
	iffie.texture = load(baseIf)
	
	resetBot()
	pass # Replace with function body.

func resetBot():
	robot.global_position = (spawnSpot)
	emit_signal("RIGHT")
	pass
	
func wait_frames(frame_count: int) -> void:
	for i in frame_count:
		await get_tree().process_frame


func _on_canceled() -> void:
	emit_signal("Gone")
	self.queue_free()
	pass # Replace with function body.

extends AcceptDialog

@onready var whiteWalk = "res://ComPuzzle Assets/buttons/WALK/Walk_Button_White.png"
@onready var walkpng = $Node2D/TextureRect
@onready var robot = $Node2D/Robot

var spawnSpot = Vector2(301.0,332.0)
signal walk
signal Gone

func _on_confirmed() -> void:
	emit_signal("walk")
	var reg = walkpng.texture
	walkpng.modulate = Color(.2588, .6275, 0)
	walkpng.texture = load(whiteWalk)
	await wait_frames(40)
	walkpng.modulate = Color(1,1,1)
	walkpng.texture = reg
	resetBot()
	pass # Replace with function body.

func resetBot():
	robot.global_position = (spawnSpot)
	pass
	
func wait_frames(frame_count: int) -> void:
	for i in frame_count:
		await get_tree().process_frame


func _on_canceled() -> void:
	emit_signal("Gone")
	self.queue_free()
	pass # Replace with function body.

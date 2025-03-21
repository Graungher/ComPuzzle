extends AcceptDialog

@onready var whiteLeft = "res://ComPuzzle Assets/buttons/TURNLEFT/Turn_Left_Button_White.png"
@onready var leftpng = $Node2D/TextureRect
@onready var robot = $Node2D/Robot

var spawnSpot = Vector2(301.0,332.0)
signal LEFT
signal RIGHT
signal Gone

func _on_confirmed() -> void:
	emit_signal("LEFT")
	var reg = leftpng.texture
	leftpng.texture = load(whiteLeft)
	await wait_frames(40)
	leftpng.texture = reg
	resetBot()
	pass # Replace with function body.

func resetBot():
	emit_signal("RIGHT")
	pass
	
func wait_frames(frame_count: int) -> void:
	for i in frame_count:
		await get_tree().process_frame


func _on_canceled() -> void:
	emit_signal("Gone")
	self.queue_free()
	pass # Replace with function body.

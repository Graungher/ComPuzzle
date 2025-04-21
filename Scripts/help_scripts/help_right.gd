extends AcceptDialog

@onready var whiteRight = "res://ComPuzzle Assets/buttons/TURNRIGHT/Turn_Right_Button_White.png"
@onready var rightpng = $Node2D/TextureRect
@onready var robot = $Node2D/Robot

var spawnSpot = Vector2(301.0,332.0)
signal LEFT
signal RIGHT
signal Gone

func _on_confirmed() -> void:
	emit_signal("RIGHT")
	var reg = rightpng.texture
	rightpng.modulate = Color(.2588, .6275, 0)
	rightpng.texture = load(whiteRight)
	await wait_frames(40)
	rightpng.modulate = Color(1,1,1)
	rightpng.texture = reg
	resetBot()
	pass # Replace with function body.

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

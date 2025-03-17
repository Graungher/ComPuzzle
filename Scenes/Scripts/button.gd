extends TextureButton


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if button_pressed and event is InputEventMouseMotion:
		global_position.x += event.relative.x
		global_position.y += event.relative.y
		

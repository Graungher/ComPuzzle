extends TextureButton


func _input(event: InputEvent) -> void:
	if button_pressed and event is InputEventMouseMotion:
		global_position.x += event.relative.x
		global_position.y += event.relative.y
		

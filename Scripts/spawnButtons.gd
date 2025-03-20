extends GridContainer

signal makeNode(node: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_loop_button_pressed() -> void:
	emit_signal("makeNode", "LOOP")
	pass # Replace with function body.


func _on_walk_button_pressed() -> void:
	emit_signal("makeNode", "WALK")
	pass # Replace with function body.


func _on_left_button_pressed() -> void:
	emit_signal("makeNode", "LEFT")
	pass # Replace with function body.


func _on_right_button_pressed() -> void:
	emit_signal("makeNode", "RIGHT")
	pass # Replace with function body.


func _on_end_loop_button_pressed() -> void:
	emit_signal("makeNode", "ENDLOOP")
	pass # Replace with function body.


func _on_if_button_pressed() -> void:
	emit_signal("makeNode", "IF")
	pass # Replace with function body.


func _on_end_if_button_pressed() -> void:
	emit_signal("makeNode", "ENDIF")
	pass # Replace with function body.


func _on_else_button_pressed() -> void:
	emit_signal("makeNode", "ELSE")
	pass # Replace with function body.

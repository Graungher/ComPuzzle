extends Window

signal Gone

func _on_canceled() -> void:
	emit_signal("Gone")
	self.queue_free()
	pass # Replace with function body.

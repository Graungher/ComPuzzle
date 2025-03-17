extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		move_child(i, 2)

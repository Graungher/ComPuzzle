extends AcceptDialog


@onready var walkHelp = preload("res://Scenes/Help_Windows/help_walk.tscn")
@onready var leftHelp = preload("res://Scenes/Help_Windows/help_left.tscn")
@onready var rightHelp = preload("res://Scenes/Help_Windows/help_right.tscn")

var theHelp: AcceptDialog

func _on_buttons_make_node(node: String) -> void:
	hide()
	match node:
		"WALK":
			theHelp = walkHelp.instantiate()
		"LEFT":
			theHelp = leftHelp.instantiate()
		"RIGHT":
			theHelp = rightHelp.instantiate()
		"LOOP":
			pass
		"IF":
			pass
		"CUSTOM":
			pass
		
	get_tree().root.add_child(theHelp)
	theHelp.connect("Gone", Callable(self, "reshow"))
	get_tree().process_frame
	theHelp.popup_centered()
	pass # Replace with function body.
	
func reshow():
	
	show()
	theHelp.queue_free()
	theHelp = null

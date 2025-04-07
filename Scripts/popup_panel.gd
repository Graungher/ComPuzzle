extends PopupPanel


@onready var list = $VBoxContainer/ScrollContainer/VBoxContainer
var selected_file = ""

signal loadMe(file_name: String)
signal openCreator

func loadList():
	var path = "LIST.txt"
	var file = FileAccess.open(path, FileAccess.READ)
	var line
	while not file.eof_reached():
		line = file.get_line()
		if line != "":
			createElement(line)
		
func createElement(line: String):
	var button = Button.new()
	button.text = line
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(_on_file_selected.bind(button.text))
	list.add_child(button)
	pass

func _on_file_selected(selected: String):
	selected_file = selected
	pass

func _on_ready() -> void:
	pass # Replace with function body.


func _on_load_button_pressed() -> void:
	emit_signal("loadMe", selected_file)
	hide()
	pass # Replace with function body.


func _on_create_button_pressed() -> void:
	emit_signal("openCreator")
	hide()
	pass # Replace with function body.


func _on_about_to_popup() -> void:
	for child in list.get_children():
		child.queue_free()
	loadList()
	pass # Replace with function body.

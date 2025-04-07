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


func _on_button_pressed() -> void:
	DirAccess.remove_absolute("user://%s.txt" % selected_file)
	remove_line_from_list_file(selected_file)
	hide()
	pass # Replace with function body.

func remove_line_from_list_file(target_line: String):
	var path = "LIST.txt"

	# Make sure the file exists
	if not FileAccess.file_exists(path):
		push_error("LIST.txt not found.")
		return

	# Read all lines
	var file = FileAccess.open(path, FileAccess.READ)
	var lines = []
	while not file.eof_reached():
		var line = file.get_line()
		if line.strip_edges() != target_line:
			lines.append(line)
	file.close()

	# Rewrite the file without the target line
	file = FileAccess.open(path, FileAccess.WRITE)
	for line in lines:
		file.store_line(line)
	file.close()

extends Node2D

@onready var menu = $Panel
@onready var grid = $GridContainer

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	pass # Replace with function body.


func _on_menu_button_pressed() -> void:
	menu.visible = not menu.visible
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func unlockButtons():
	var path = "user://UNLOCKED.txt"
	var file = FileAccess.open(path, FileAccess.READ_WRITE)
	var unlock = int(file.get_line())
	file.close()
	var child
	
	for i in unlock:
		child = grid.get_child(i)
		child.disabled = false
		pass
	pass

func _on_ready() -> void:
	unlockButtons()
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/play.tscn")
	pass # Replace with function body.

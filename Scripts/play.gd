extends Node2D

@onready var warnWindow = $Warning_window
@onready var menu = $Panel


func _on_continue_pressed() -> void:
	var path = "user://UNLOCKED.txt"
	var file = FileAccess.open(path, FileAccess.READ)
	var curMap = int(file.get_line())
	mapList.select_map(curMap)
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	pass # Replace with function body.


func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
	pass # Replace with function body.

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	pass

func _on_tutorial_pressed() -> void:
	pass # Replace with function body.


func _on_new_game_pressed() -> void:
	mapList.select_map(0)
	var path = "user://UNLOCKED.txt"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(str(1))
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	pass # Replace with function body.


func _show_warning_window() -> void:
	warnWindow.popup()
	pass # Replace with function body.


func _on_warning_window_canceled() -> void:
	pass # Replace with function body.


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	pass # Replace with function body.


func _on_menu_button_pressed() -> void:
	menu.visible = not menu.visible
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

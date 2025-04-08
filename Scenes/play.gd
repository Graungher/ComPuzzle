extends Node2D





func _on_continue_pressed() -> void:
	var curMap = mapList.getCurrentMap()
	mapList.select_map(curMap)
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	pass # Replace with function body.


func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
	pass # Replace with function body.


func _on_tutorial_pressed() -> void:
	pass # Replace with function body.


func _on_new_game_pressed() -> void:
	mapList.select_map(0)
	var path = "user://UNLOCKED.txt"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(str(1))
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	pass # Replace with function body.

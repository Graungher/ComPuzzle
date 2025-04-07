extends Node2D

@onready var menu = $Panel

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	pass # Replace with function body.


func _on_menu_button_pressed() -> void:
	menu.visible = not menu.visible
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

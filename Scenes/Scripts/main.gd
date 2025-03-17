extends Node2D


func _ready():
	pass
	
	
func _on_quit_pressed() -> void:
	get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	

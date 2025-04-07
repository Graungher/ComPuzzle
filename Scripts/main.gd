extends Node2D


func _ready():
	pass
	
	
func _on_quit_pressed() -> void:
	get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_play_pressed() -> void:
	var path = "user://LIST.txt"
	var file = FileAccess.open(path, FileAccess.READ_WRITE)
	if not FileAccess.file_exists(path):
		file = FileAccess.open(path, FileAccess.WRITE)
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	

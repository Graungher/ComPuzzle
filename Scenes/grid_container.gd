extends GridContainer

var map_num = 0

func changemap(mapnum: int):
	mapnum -= 1
	mapList.select_map(mapnum)
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	

func _on_map_1_pressed() -> void:
	changemap(1)
	pass # Replace with function body.


func _on_map_2_pressed() -> void:
	changemap(2)
	pass # Replace with function body.


func _on_map_3_pressed() -> void:
	changemap(3)
	pass # Replace with function body.


func _on_map_4_pressed() -> void:
	changemap(4)
	pass # Replace with function body.

func _on_map_5_pressed() -> void:
	changemap(5)
	pass # Replace with function body.


func _on_map_6_pressed() -> void:
	changemap(6)
	pass # Replace with function body.


func _on_map_7_pressed() -> void:
	changemap(7)
	pass # Replace with function body.


func _on_map_8_pressed() -> void:
	changemap(8)
	pass # Replace with function body.

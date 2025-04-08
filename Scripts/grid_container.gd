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


func _on_map_9_pressed() -> void:
	changemap(9)
	pass # Replace with function body.


func _on_map_10_pressed() -> void:
	changemap(10)
	pass # Replace with function body.
	

func _on_map_11_pressed() -> void:
	changemap(11)
	pass # Replace with function body.
	
func _on_map_12_pressed() -> void:
	changemap(12)
	pass # Replace with function body.
	

func _on_map_13_pressed() -> void:
	changemap(13)
	pass # Replace with function body.
	

func _on_map_14_pressed() -> void:
	changemap(14)
	pass # Replace with function body.
	

func _on_map_15_pressed() -> void:
	changemap(15)
	pass # Replace with function body.
	
	
func _on_map_16_pressed() -> void:
	changemap(16)
	pass # Replace with function body.
	
	
func _on_map_17_pressed() -> void:
	changemap(17)
	pass # Replace with function body.
	

func _on_map_18_pressed() -> void:
	changemap(18)
	pass # Replace with function body.
	

func _on_map_19_pressed() -> void:
	changemap(19)
	pass # Replace with function body.
	

func _on_map_20_pressed() -> void:
	changemap(20)
	pass # Replace with function body.

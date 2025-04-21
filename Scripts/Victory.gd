extends TextureRect
signal change
signal select
signal replay

@onready var instructs_used = $Label
@onready var bestLabel = $bestLabel

var totalInstructions = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_level_pressed() -> void:
	emit_signal("change");	
	hide()
	pass
	


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	hide()
	pass # Replace with function body.


func _on_level_select_pressed() -> void:
	emit_signal("select")
	pass # Replace with function body.


func _on_replay_pressed() -> void:
	emit_signal("replay")
	hide()
	pass # Replace with function body.


func _on_button_pressed() -> void:
	pass # Replace with function body.
	
func setTotalInst(instructions: int):
	var str = "00"
	if instructions < 10:
		str[0] = '0'
		str[1] = str(instructions)
	else:
		str = str(instructions)
	instructs_used.text = str
	pass
	
func setBest(best: int):
	bestLabel.text = str(best)
	pass

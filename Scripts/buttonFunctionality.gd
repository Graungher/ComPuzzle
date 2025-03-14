extends TextureButton

#@onready var number_label = $NumberLabel
#@onready var hidden_label = $HiddenLabel
@onready var up_button = $UpButton
@onready var down_button = $DownButton
@onready var label = $Label
@onready var text = $loopCount
@export var spawnscene: PackedScene
signal makeMe(button: TextureButton)
signal mover(move: int, button: TextureButton) 
signal deleteMe(button: TextureButton)

var count := 0

func _ready():
	if text:
		$loopCount.custom_minimum_size = Vector2(38, 30)
		$loopCount.size = Vector2(20, 13)
	pass

func _on_up_button_pressed():
	emit_signal("mover", 1,self)

func _on_down_button_pressed():
	emit_signal("mover", -1,self)


func _on_pressed():
	emit_signal("makeMe", label.text)
	pass # Replace with function body.


func _on_delete_button_pressed() -> void:
	emit_signal("deleteMe", self)
	pass # Replace with function body.


func _on_decrease_loops_pressed() -> void:
	count = int(text.text)
	if count > 0:
		text.text = str(count - 1)
	else:
		#error signal here#######################################################
		pass
	pass # Replace with function body.


func _on_increase_loops_pressed() -> void:
	count = int(text.text)
	text.text = str(count + 1)
	pass # Replace with function body.


func _on_line_edit_focus_entered() -> void:
	text.text = ""
	text.placeholder_text = ""
	pass # Replace with function body.

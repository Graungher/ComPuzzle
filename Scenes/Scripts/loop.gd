extends TextureButton

var loopAmt = 0

# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if button_pressed and event is InputEventMouseMotion:
		global_position.x += event.relative.x
		global_position.y += event.relative.y
		

@onready var texture_button: TextureButton = $"."
@onready var texture_button_2: TextureButton = $"../TextureButton2"
@onready var texture_button_3: TextureButton = $"../TextureButton3"
@onready var texture_button_4: TextureButton = $"../TextureButton4"


func _ready() -> void:
	#confirm_button.pressed.connect(on_confirm_button_pressed)
	pass

func on_confirm_button_pressed() -> void:
	# Get the positions of the draggable blocks
	var texture_button: Vector2 = texture_button.global_position
	var texture_button_2: Vector2 = texture_button_2.global_position
	var texture_button_3: Vector2 = texture_button_3.global_position
	var texture_button_4: Vector2 = texture_button_4.global_position

	# Determine the direction or action based on block positions
	#if block_1_position.x > block_2_position.x:
		#move_right()
	#elif block_1_position.x < block_2_position.x:
		#move_left()
	#if block_1_position.y > block_2_position.y:
		#move_down()
	#elif block_1_position.y < block_2_position.y:
		#move_up()

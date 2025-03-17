extends Control

@onready var walk_block: TextureButton = $CanvasLayer/Control/WalkBlock
@onready var turn_left_block: TextureButton = $CanvasLayer/Control/TurnLeftBlock
@onready var turn_right_block: TextureButton = $CanvasLayer/Control/TurnRightBlock
@onready var loop_block: TextureButton = $CanvasLayer/Control/LoopBlock
@onready var confirm_button: Button = $CanvasLayer/Control/ConfirmButton

var blocks_in_play_area: Array = []  # Stores blocks in the play area

func _ready() -> void:
	#confirm_button.pressed.connect(on_confirm_button_pressed)
	pass

func on_confirm_button_pressed() -> void:
	# Clear the play area and process blocks
	blocks_in_play_area.clear()
	find_blocks_in_play_area()

	# Execute the actions
	execute_actions()

func find_blocks_in_play_area() -> void:
	# Define the play area (e.g., a specific region of the screen)
	var play_area: Rect2 = Rect2(Vector2(100, 100), Vector2(400, 400))

	# Check if blocks are within the play area
	for block in [walk_block, turn_left_block, turn_right_block, loop_block]:
		if play_area.has_point(block.global_position):
			blocks_in_play_area.append(block)

func execute_actions() -> void:
	for block in blocks_in_play_area:
		match block.block_type:
			block.BlockType.WALK:
				walk()
			block.BlockType.TURN_LEFT:
				turn_left()
			block.BlockType.TURN_RIGHT:
				turn_right()
			block.BlockType.LOOP:
				loop()

func walk() -> void:
	print("Walking Forward")
	# Add your walk logic here (e.g., move the sprite forward)

func turn_left() -> void:
	print("Turning Left")
	# Add your turn left logic here (e.g., rotate the sprite -90 degrees)

func turn_right() -> void:
	print("Turning Right")
	# Add your turn right logic here (e.g., rotate the sprite +90 degrees)

func loop() -> void:
	print("Looping")
	# Add your loop logic here (e.g., repeat the sequence of actions)

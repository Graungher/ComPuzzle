extends CharacterBody2D

const SPEED = 130.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#get direction inputs
	var direction := Input.get_axis("Move left", "Move right")
	var direction2 := Input.get_axis("Move up", "Move down")
	
	#flip sprites
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	#apply movement
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")
	if direction2:
		velocity.y = direction2 * SPEED
		if velocity.y > 0:
			anim.play("Walk down")
		elif velocity.y < 0:
			anim.play("Walk up")
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		if velocity.x == 0:
			anim.play("Idle")

	move_and_slide()

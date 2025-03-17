extends CharacterBody2D

var SPEEDX = 130.0
var SPEEDY = 130.0
var TileSize = 32
var VERTICAL_TILE_DISTANCE = 32
var HORIZONTAL_TILE_DISTANCE = 32
var compass: String = "south"
var is_moving = false
var defaultScaleX = 0.484
var defaultScaleY = 0.664

signal tookStep

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	pass

func _turnLeft():
	match compass:
		"north":
			compass = "west"
			anim.flip_h = true
			anim.play("walk")
		"south":
			compass = "east"
			anim.flip_h = false
			anim.play("walk")
		"east":
			compass = "north"
			anim.play("Walk up")
		"west":
			compass = "south"
			anim.play("Idle")


func _turnRight():
	match compass:
		"north":
			compass = "east"
			anim.flip_h = false
			anim.play("walk")
		"south":
			compass = "west"
			anim.flip_h = true
			anim.play("walk")
		"east":
			compass = "south"
			anim.play("Idle")
		"west":
			compass = "north"
			anim.play("Walk up")


func _walk():
	if is_moving:
		return
	
	is_moving = true
	var target_pos = position
	var tween = create_tween()
	match compass:
		"north":
			target_pos += Vector2(0 ,-VERTICAL_TILE_DISTANCE)
			tween.tween_property(self,"position", target_pos, VERTICAL_TILE_DISTANCE / SPEEDY)
		"south":
			target_pos += Vector2(0 ,VERTICAL_TILE_DISTANCE)
			tween.tween_property(self,"position", target_pos, VERTICAL_TILE_DISTANCE / SPEEDY)
		"east":
			target_pos += Vector2(HORIZONTAL_TILE_DISTANCE,0)
			tween.tween_property(self,"position", target_pos, HORIZONTAL_TILE_DISTANCE / SPEEDX)
		"west":
			target_pos += Vector2(-HORIZONTAL_TILE_DISTANCE,0)
			tween.tween_property(self,"position", target_pos, HORIZONTAL_TILE_DISTANCE / SPEEDX)
	
	await tween.finished
	is_moving = false


func deleteRobot():
	queue_free()


func getCurrentPosition():
	return global_position


func getFacing():
	return compass


func SetMapStuff(scaleX: float, scaleY: float):
	VERTICAL_TILE_DISTANCE = TileSize * scaleY
	HORIZONTAL_TILE_DISTANCE = TileSize * scaleX
	SPEEDX *= scaleX
	SPEEDY *= scaleY
	
	anim.scale = Vector2(defaultScaleX * scaleX, defaultScaleY * scaleY)
	pass

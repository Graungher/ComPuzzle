extends CharacterBody2D

const SPEED = 130.0
const TILE_DISTANCE = 32
var compass: String = "south"
var is_moving = false
var tilemap
signal tookStep

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	update_tilemap_reference()



func update_tilemap_reference():
	var game_node = get_parent()
	await get_tree().process_frame
	tilemap = game_node.get_current_map()
	#if tilemap:
		#print("got a map")

func print_tile_location():
	var local_pos = tilemap.to_local(global_position)
	var tile_position = tilemap.local_to_map(local_pos)
	print("Player Position:", tile_position)

func _get_tile_data():
	var local_pos = tilemap.to_local(global_position)
	var tile_position = tilemap.local_to_map(local_pos)

	match compass:
		"north":
			tile_position += Vector2i(0,-1)
		"south":
			tile_position += Vector2i(0,1)
		"east":
			tile_position += Vector2i(1,0)
		"west":
			tile_position += Vector2i(-1,0)
			
	#print("Facing Tile Position:", tile_position)
	var tile_data = tilemap.get_cell_tile_data(1, tile_position)
	
	if tile_data:
		if tile_data.get_custom_data("Object"):  # Access custom data by name
			print("Tile in front has 'object' set to TRUE")
			pass
		else:
			print("Tile in front has 'object' set to FALSE")
			pass
	else:
		print("No tile at", tile_position)
		pass
	print("tile info: ", tile_data)
	return tile_data
	
func _turnLeft():
	#print("should turn left")
	#print("Former Direction:", compass)  # Debugging print
	
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
		
	#print("Current Direction:", compass)  # Debugging print

func _turnRight():
	#print("Former Direction:", compass)  # Debugging print
	
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
			
	#print("Current Direction:", compass)  # Debugging print
	
	
	
func _walk():
	print("RECIEVED WALK")
	if is_moving:
		return
	
	var can_walk = true
	var tile_data = _get_tile_data()
	if tile_data:
		if tile_data.get_custom_data("Object"):
			can_walk = false
	
	if can_walk:
		is_moving = true
		var target_pos = position
		match compass:
			"north":
				target_pos += Vector2(0 ,-TILE_DISTANCE)
			"south":
				target_pos += Vector2(0 ,TILE_DISTANCE)
			"east":
				target_pos += Vector2(TILE_DISTANCE,0)
			"west":
				target_pos += Vector2(-TILE_DISTANCE,0)
		var tween = create_tween()
		tween.tween_property(self,"position", target_pos, TILE_DISTANCE / SPEED)
		
		await tween.finished
		is_moving = false
		print_tile_location()
		emit_signal("tookStep")
		
func deleteRobot():
	queue_free()
	
func getCurrentPosition():
	return global_position
	pass

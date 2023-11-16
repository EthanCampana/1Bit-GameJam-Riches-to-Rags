extends TileMap

var tile_data = {}  # Dictionary to store data for each" tile
var label_scene = preload("res://Scenes/Tile_Label.tscn")
#var moisture = FastNoiseLite.new()
#var temperature = FastNoiseLite.new()
#var altitude = FastNoiseLite.new()
var width = 40
var height = 60

var dict_preffered_tiles = {0: .80, 1: .30, 2: .15, 3: .30}


func _ready():
#	moisture.seed j= randi()
#	temperature.seed = randi()
#	altitude.seed = randi()
	generate_chunk(Vector2i(20,20))
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (Input.is_action_just_pressed("leftClick")):
		var tile = local_to_map(get_global_mouse_position())
		set_cell(0, tile, 0, Vector2(2,0), 0)
	if(Input.is_action_just_pressed("rightClick")):
		var tile = local_to_map(get_global_mouse_position())
		erase_cell(0, tile)
		
	#generate_simple_level()
	
func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
#			var moist = moisture.get_noise_2d(tile_pos.x + x, tile_pos.y + y)
#			var temp = temperature.get_noise_2d(tile_pos.x + x, tile_pos.y + y)
#			var alt = altitude.get_noise_2d(tile_pos.x + x, tile_pos.y + y)
			var ID = pick_random_ID()
			print(ID)
			set_cell(0, Vector2i(tile_pos.x + x, tile_pos.y + y), ID, random_tile_selector(ID))
			var random_number = randi() % 8  # Generates a random number between 0 and 7
			tile_data[tile_pos] = random_number
				# Not working properly. 
			
		#	var label = label_scene.instance()
		#	var tile_world_position = local_to_map(tile_position + Vector2(tile_set.cell_size.x / 2, tile_set.cell_size.y  / 2))
		#	label.rect_position = tile_world_position
		#	label.text = str(random_number)
		#	get_parent().add_child(label)  # Adding the label to the TileMap's parent node

func random_tile_selector(ID_number) -> Vector2i:
	if ID_number == 0:
		return Vector2i(0,1)
	elif ID_number == 1:
		return Vector2i(0,0)
	elif ID_number == 2:
		return Vector2i(0,1)
	elif ID_number == 3:
		return Vector2i(0,0)
	return Vector2i(0,0)
	
	
func get_tile_number(tile_position):
	if tile_data.has(tile_position):
		return tile_data[tile_position]
	else:
		return null  # Or any other default value


func pick_random_layer() -> int:
	return randi() % 8


func pick_random_ID() -> int:
	for ID_val in dict_preffered_tiles:
		print(dict_preffered_tiles[ID_val])
		if dict_preffered_tiles[ID_val] > randf() :
			return ID_val
	return 0
	
	
# After each turn, update the tiles with their modulate
func update_layers_modulatity():
	for x_position in width:
		for y_position in height:
			#We need to get current layer, set the new one and decrease it by one.
			var tile_pos = Vector2(x_position, y_position)
			set_cell(pick_random_ID(), tile_pos, 0, Vector2(2,0), 0)
			
#func tile_fall_down(tile_position):
	
	
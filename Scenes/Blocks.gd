extends TileMap

var tile_data = {}  # Dictionary to store data for each" tile
var label_scene = preload("res://Scenes/Tile_Label.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("leftClick")):
	
		var tile = local_to_map(get_global_mouse_position())
		set_cell(0, tile, 0, Vector2(2,0), 0)
	if(Input.is_action_just_pressed("rightClick")):
		var tile = local_to_map(get_global_mouse_position())
		erase_cell(0, tile)
		
	generate_simple_level()

func set_tile_with_random_number(tile_position):
	var random_number = randi() % 8  # Generates a random number between 0 and 7
	set_cell(0, tile_position, 0, Vector2(2,0), 0)  # Assuming '0' is your tile ID
	
	# Not working properly. 
	
#	var label = label_scene.instance()
#	var tile_world_position = local_to_map(tile_position + Vector2(tile_set.cell_size.x / 2, tile_set.cell_size.y  / 2))
#	label.rect_position = tile_world_position
#	label.text = str(random_number)
#	get_parent().add_child(label)  # Adding the label to the TileMap's parent node
	

func get_tile_number(tile_position):
	if tile_data.has(tile_position):
		return tile_data[tile_position]
	else:
		return null  # Or any other default value

func generate_simple_level():
	for x_position in 50:
		for y_position in 50:
			var tile_pos = Vector2(x_position, y_position)
			set_cell(0, tile_pos, 0, Vector2(2,0), 0)
			set_tile_with_random_number(tile_pos)

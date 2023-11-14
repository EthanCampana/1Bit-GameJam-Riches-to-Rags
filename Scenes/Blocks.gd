extends TileMap

var tile_data = {}  # Dictionary to store data for each" tile
var label_scene = preload("res://Scenes/Tile_Label.tscn")
#var moisture = FastNoiseLite.new()
#var temperature = FastNoiseLite.new()
#var altitude = FastNoiseLite.new()
var width = 20
var height = 30

var GameState = []

class StateData:
	var layer : int
	var tile_position : Vector2i
	var texture : Vector2i


func _ready():
#	moisture.seed j= randi()
#	temperature.seed = randi()
#	altitude.seed = randi()
	generate_chunk(Vector2i(20,20))
	var i : StateData = StateData.new()
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (Input.is_action_just_pressed("leftClick")):
		var tile = local_to_map(get_global_mouse_position())
		movement(tile)
		
	if(Input.is_action_just_pressed("rightClick")):
		clear_layer(0)
	#generate_simple_level()
	
func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
#			var moist = moisture.get_noise_2d(tile_pos.x + x, tile_pos.y + y)
#			var temp = temperature.get_noise_2d(tile_pos.x + x, tile_pos.y + y)
#			var alt = altitude.get_noise_2d(tile_pos.x + x, tile_pos.y + y)
			set_cell(pick_random_layer(), Vector2i(tile_pos.x + x, tile_pos.y + y), 0, random_tile_selector())
			var random_number = randi() % 8  # Generates a random number between 0 and 7
			tile_data[tile_pos] = random_number
				# Not working properly. 
			#set_layer_modulate(0, Color(1,1,1,0.5))
		#	var label = label_scene.instance()
		#	var tile_world_position = local_to_map(tile_position + Vector2(tile_set.cell_size.x / 2, tile_set.cell_size.y  / 2))
		#	label.rect_position = tile_world_position
		#	label.text = str(random_number)
		#	get_parent().add_child(label)  # Adding the label to the TileMap's parent node

func random_tile_selector() -> Vector2i:
	var list_of_tiles = [Vector2i(2,0),Vector2i(4,0),Vector2i(6,0)]	
	list_of_tiles.shuffle()
	return list_of_tiles[0]
	
func get_tile_number(tile_position):
	if tile_data.has(tile_position):
		return tile_data[tile_position]
	else:
		return null  # Or any other default value

func generate_simple_level():
	for x_position in 50:
		for y_position in 50:
			var tile_pos = Vector2(x_position, y_position)
			set_cell(9, tile_pos, 0, Vector2(2,0), 0)
			#set_tile_with_random_number(tile_pos)


func pick_random_layer() -> int:
	return randi() % 2 + 3

# After each turn, update the tiles with their modulate
func update_layers_modulatity():
	for x_position in width:
		for y_position in height:
			#We need to get current layer, set the new one and decrease it by one.
			var tile_pos = Vector2(x_position, y_position)
			set_cell(0, tile_pos, 0, Vector2(2,0), 0)

func movement(pos: Vector2i):
	var m = movementDFS(pos)
	var i = 0
	for posi in m:
		if i == 0:
			i+=1
			continue
		set_cell(0, posi, 0, Vector2(1,0), 0)		


func getUsedTiles():
	var usedTiles = []
	usedTiles += get_used_cells(0)
	usedTiles += get_used_cells(1)
	usedTiles += get_used_cells(2)
	usedTiles += get_used_cells(3)
	usedTiles += get_used_cells(4)
	usedTiles += get_used_cells(5)
	usedTiles += get_used_cells(6)
	usedTiles += get_used_cells(7)
	return usedTiles

func getUsedTilesAppended():
	var usedTiles = []
	usedTiles.append( get_used_cells(0))
	usedTiles.append(get_used_cells(1))
	usedTiles.append( get_used_cells(2))
	usedTiles.append( get_used_cells(3))
	usedTiles.append(get_used_cells(4))
	usedTiles.append( get_used_cells(5))
	usedTiles.append(get_used_cells(6))
	usedTiles.append( get_used_cells(7))
	return usedTiles




func saveGameState(tileLocations):
	var appendedstate = getUsedTilesAppended()
	for location in tileLocations:
		var i = 0 
		for list in appendedstate:
			if location in list:
				var tileState = StateData.new()
				tileState.layer = i
				tileState.tile_position = location
				tileState.texture =  get_cell_tile_data(i,location).texture_origin
				GameState.append(tileState)
			i+=1

func RestoreGameState():
	for state in GameState:
		set_cell(state.layer, state.tile_position, 0, state.texture, 0)
	GameState.clear()
	




func movementDFS(pos : Vector2i):
	var speed = 2 
	var discovered = []
	var stack = []
	var usedTiles = getUsedTiles() 
	if pos not in usedTiles:
		return discovered
	stack.append(pos)
	while speed >= 0:
		var cur_band = stack
		stack = []
		while !cur_band.is_empty():
			var current = cur_band.pop_back()
			if current not in discovered and current in usedTiles:
				discovered.append(current)
				if speed > 0:
					stack += get_surrounding_cells(current)
					stack.append(Vector2i(current.x+1,current.y))
					stack.append(Vector2i(current.x-1,current.y))
					stack.append(Vector2i(current.x,current.y-2))
					stack.append(Vector2i(current.x,current.y+2))

		speed -= 1
	saveGameState(discovered)
	return discovered

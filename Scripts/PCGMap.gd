extends TileMap
class_name PCGTileMap

@export var width : int = 20
@export var height : int = 30

var mapData = []
var dict_preffered_tiles = {0: .80, 1: .30, 2: .15, 3: .30}

var worldCycle = 0 



func updateLayerOpacity():
	for i in range(get_layers_count()-1):
		if worldCycle + 2  >= i:
			var col = get_layer_modulate(i)
			col.a = .3
			set_layer_modulate(i,col)
		elif worldCycle + 5  >= i:
			var col = get_layer_modulate(i)
			col.a = .7
			set_layer_modulate(i,col)
		elif worldCycle + 6  >= i:
			var col = get_layer_modulate(i)
			col.a = .9
			set_layer_modulate(i,col)

			




func calculateTileLocation(tile : Vector2i):
	print(tile)
	var endlocation : Vector2				
	var global = map_to_local(tile)	
	endlocation.x = global.x
	endlocation.y = global.y - (1 * 128/ 2)
	return [endlocation, tile]


func get_spawn_location():
	while true:
		var tile = mapData.pick_random()		
		var id = getTileID(tile)
		if id == 0 or id == 2:
			return calculateTileLocation(tile)

func random_tile_selector(ID_number) -> Vector2i:
	var list_of_tiles = [Vector2i(0,1),Vector2i(0,0),Vector2i(0,0)]	
	if ID_number == 0:
		return Vector2i(0,1)
	elif ID_number == 1:
		return Vector2i(0,0)
	elif ID_number == 2:
		return Vector2i(0,1)
	elif ID_number == 3:
		return Vector2i(0,0)
	return Vector2i(0,0)
	
	

func generate_chunk():
	var tile_pos = local_to_map(Vector2i(20,20))
	for x in range(width):
		for y in range(height):
			var ID = pick_random_ID()
			set_cell(pick_random_layer(), Vector2i(tile_pos.x + x, tile_pos.y + y), ID, random_tile_selector(ID))



func pick_random_layer() -> int:
	return randi() % 8


func pick_random_ID() -> int:
	for ID_val in dict_preffered_tiles:
			print(dict_preffered_tiles[ID_val])
			if dict_preffered_tiles[ID_val] > randf() :
				return ID_val
	return 0



func normalize():
	worldCycle +=1
	var i = 0
	while i < worldCycle:
		clear_layer(i)
		i+=1
	updateMapData()
	updateLayerOpacity()
	GameController.emit_signal("check_death")
	




func getTileLayer(tile):
	for i in range(get_layers_count()):
		if tile in get_used_cells(i):
			return i
	return null

func checkTileInMap(tile):
	if tile in mapData:
		return true
	else:
		return false

func updateMapData():
	for x in range(get_layers_count()):
		mapData += get_used_cells(x)


func updateOccupiedTileData(tile,occupied):
	if !checkTileInMap(tile):
		return
	var layer = getTileLayer(tile)
	var data = get_cell_tile_data(layer,tile)
	data.set_custom_data("occupied",occupied)

func getOccupiedTileData(tile):
	var layer = getTileLayer(tile)
	if layer == null:
		return null
	var data = get_cell_tile_data(layer,tile)
	if data == null:
		return null	
	var custom_data = data.get_custom_data("occupied")
	return custom_data




func getTileID(tile):
	var layer = getTileLayer(tile)
	if layer == null:
		return 99
	var data = get_cell_tile_data(layer,tile)
	var id = data.get_custom_data("ID")
	if id == null:
		return 99 
	return id

	

func updateMovementTiles(champ):
	var moveTiles = []
	var realMoves = []
	var grid_pos = champ.tile_position
	moveTiles += get_surrounding_cells(grid_pos)
	# if Vector2i(grid_pos.x+1,grid_pos.y) in mapData:
	# 	moveTiles.append(Vector2i(grid_pos.x+1,grid_pos.y))	
	# if Vector2i(grid_pos.x-1,grid_pos.y) in mapData:
	# 	moveTiles.append(Vector2i(grid_pos.x-1,grid_pos.y))	
	# if Vector2i(grid_pos.x,grid_pos.y-2) in mapData:
	# 	moveTiles.append(Vector2i(grid_pos.x,grid_pos.y-2))	
	# if Vector2i(grid_pos.x,grid_pos.y+2) in mapData:
	# 	moveTiles.append(Vector2i(grid_pos.x,grid_pos.y+2))	
	for tile in moveTiles:
		var id = getTileID(tile)
		var c = GameController.getChampionAtTile(tile)
		if c != null:
			continue
		if id == 0 or id == 2:
			realMoves.append(tile)
	showMoveTiles(realMoves)	
	return realMoves

func showMoveTiles(tiles):
	clear_layer(8)
	for cell in tiles:
		set_cell(8,cell,0,Vector2i(0,1),0)

# Called when the node enters the scene tree for the first time.
func _ready():
	updateMapData()
	updateLayerOpacity()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

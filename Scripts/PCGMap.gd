extends TileMap
class_name PCGTileMap

var layerData= []	 
var mapData = []



var worldCycle = 0 


func normalize():
	worldCycle +=1
	var i = 0
	while i < worldCycle:
		clear_layer(i)
	updateMapData()



func getTileLayer(tile):
	var i = 0
	for layer in layerData:
		if tile in layer:
			return i
		i += 1

func checkTileInMap(tile):
	if tile in mapData:
		return true
	else:
		return false

func updateMapData():
	for x in range(get_layers_count()):
		layerData.append(get_used_cells(x))
		mapData += get_used_cells(x)


func updateOccupiedTileData(tile,occupied):
	if !checkTileInMap(tile):
		return
	var layer = getTileLayer(tile)
	var data = get_cell_tile_data(layer,tile)
	data.set_custom_data("occupied",occupied)

func getOccupiedTileData(tile):
	var layer = getTileLayer(tile)
	var data = get_cell_tile_data(layer,tile)
	var custom_data = data.get_custom_data("occupied")
	return custom_data



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

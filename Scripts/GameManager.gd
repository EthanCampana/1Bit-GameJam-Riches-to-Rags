extends Node

var currentTurn : int
var currentChamp: Champion
var turnOrder = []
var map : PCGTileMap
var tile_size = 128 # This number will change
var camera : GameCamera


@onready var warrior : Champion = $Warrior
var wizard : Champion
var rogue : Champion


var skillToggled : bool
var shownMovedTiles: bool

var layerData= []	 
var mapData = []
var moveTiles = []

# Need to create a Singleton Game Manageer to inform the GameManager about stuff
# Need to think about sound implementation





func updateMapData():
	for x in range(map.get_layers_count()):
		layerData.append(map.get_used_cells(x))
		mapData += map.get_used_cells(x)




func updateMovementTiles():
	moveTiles = []
	var grid_pos = map.local_to_map(currentChamp.position)
	moveTiles += map.get_surrounding_cells(grid_pos)
	if Vector2i(grid_pos.x+1,grid_pos.y) in mapData:
		moveTiles.append(Vector2i(grid_pos.x+1,grid_pos.y))	
	if Vector2i(grid_pos.x-1,grid_pos.y) in mapData:
		moveTiles.append(Vector2i(grid_pos.x-1,grid_pos.y))	
	if Vector2i(grid_pos.x,grid_pos.y-2) in mapData:
		moveTiles.append(Vector2i(grid_pos.x,grid_pos.y-2))	
	if Vector2i(grid_pos.x,grid_pos.y+2) in mapData:
		moveTiles.append(Vector2i(grid_pos.x,grid_pos.y+2))	



func showMovementTiles():
	for cell in moveTiles:
		map.set_cell(9,cell,map.get_cell_source_id(1,cell),map.get_cell_atlas_coords(1,cell),0)
	shownMovedTiles = true
	


func playerMove(location : Vector2i):
	map.updateOccupiedTileData(map.local_to_map(currentChamp.position),TYPE_NIL )
	map.updateOccupiedTileData(location,currentChamp)
	var tween = get_tree().create_tween()
	tween.tween_property(currentChamp,"position",calculateTileLocation(location),2).set_trans(tween.TRANS_SINE) 
	await tween.finished



func calculateTileLocation(tile : Vector2i):
	var endlocation : Vector2				
	var global = map.map_to_local(tile)	
	endlocation.x = global.x
	endlocation.y = global.y - (1 * tile_size / 2)
	return endlocation



func handleInput():
	if !shownMovedTiles:
		updateMovementTiles()
		showMovementTiles()
	if Input.is_action_just_pressed("leftClick"):
		if currentChamp.movement_speed != 0 && map.local_to_map(map.get_global_mouse_position()) in moveTiles:
			currentChamp.movement_speed -=1
			playerMove(map.local_to_map(map.get_global_mouse_position()))


func startTurn():
	currentChamp = turnOrder[currentTurn]
	currentChamp.normalize()
	camera.target_node = currentChamp


func endTurn():
	currentTurn += 1 % turnOrder.size() 
	if currentTurn == 0:
		map.normalize()
	startTurn()

# Called when the node enters the scene tree for the first time.
func _ready():
	GameController.connect("skill_toggled",self.on_skill_toggled)
	turnOrder = [warrior, wizard, rogue]
	turnOrder.shuffle()
	for champ in turnOrder:
		champ.map = map
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !skillToggled:
		handleInput()



func on_check_death():
	for champ in turnOrder:
		if !map.checkTileInMap(map.local_to_map(champ.position)):
			champ.queue_free()


func on_skill_toggled(on: bool):
	skillToggled = on

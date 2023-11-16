extends Node

var currentTurn : int
var currentChamp: Champion
var turnOrder = []
@onready var map : PCGTileMap = $PCGMap
var tile_size = 128 # This number will change
@onready var camera : GameCamera = $GameCamera



@onready var warrior : Champion = $Warrior
@onready var wizard : Champion  = $Wizard
@onready var rouge : Champion = $Rouge


var skillToggled : bool
var shownMovedTiles: bool
var mapGenerated : bool	 = false
var layerData= []	 
var mapData = []
var moveTiles = []
var moving : bool = false

# Need to create a Singleton Game Manageer to inform the GameManager about stuff
# Need to think about sound implementation





func updateMapData():
	for x in range(map.get_layers_count()):
		layerData.append(map.get_used_cells(x))
		mapData += map.get_used_cells(x)



func showMovement():
	moveTiles = map.updateMovementTiles(currentChamp)
	shownMovedTiles = true

# func updateMovementTiles():
# 	# moveTiles = []
# 	# var grid_pos = map.local_to_map(currentChamp.position)
# 	# moveTiles += map.get_surrounding_cells(grid_pos)
# 	# if Vector2i(grid_pos.x+1,grid_pos.y) in mapData:
# 	# 	moveTiles.append(Vector2i(grid_pos.x+1,grid_pos.y))	
# 	# if Vector2i(grid_pos.x-1,grid_pos.y) in mapData:
# 	# 	moveTiles.append(Vector2i(grid_pos.x-1,grid_pos.y))	
# 	# if Vector2i(grid_pos.x,grid_pos.y-2) in mapData:
# 	# 	moveTiles.append(Vector2i(grid_pos.x,grid_pos.y-2))	
# 	# if Vector2i(grid_pos.x,grid_pos.y+2) in mapData:
# 	# 	moveTiles.append(Vector2i(grid_pos.x,grid_pos.y+2))	
# 	moveTiles = map.updateMovementTiles(currentChamp)



# func showMovementTiles():
# 	shownMovedTiles = true
# 	# for cell in moveTiles:
# 	# 	map.set_cell(9,cell,map.get_cell_source_id(1,cell),map.get_cell_atlas_coords(1,cell),0)
# 	# shownMovedTiles = true
	


func playerMove(location : Vector2i):
	moving = true
	currentChamp.tile_position = location
	var tween = get_tree().create_tween()
	tween.tween_property(currentChamp,"position",calculateTileLocation(location),.5).set_trans(tween.TRANS_SINE) 
	await tween.finished
	shownMovedTiles = false
	moving = false
	map.clear_layer(8)
	



func calculateTileLocation(tile : Vector2i):
	var endlocation : Vector2				
	var global = map.map_to_local(tile)	
	endlocation.x = global.x
	endlocation.y = global.y - (1 * tile_size / 2)
	return endlocation



func handleInput():
	if !shownMovedTiles and currentChamp.movement_speed != 0:
		# updateMovementTiles()
		# showMovementTiles()
		showMovement()
	if Input.is_action_just_pressed("leftClick"):
		if currentChamp.movement_speed != 0 && map.local_to_map(map.get_global_mouse_position()) in moveTiles && !moving:
			currentChamp.movement_speed -=1
			print(currentChamp.movement_speed)
			playerMove(map.local_to_map(map.get_global_mouse_position()))
		
	if Input.is_action_just_pressed("rightClick"):
		print(map.local_to_map(map.get_global_mouse_position()))
	if Input.is_action_just_pressed("Skill1"):
		currentChamp.useSkill(0)
	if Input.is_action_just_pressed("Skill2"):
		currentChamp.useSkill(1)
	if Input.is_action_just_pressed("Skill3"):
		currentChamp.useSkill(2)
	if Input.is_action_just_pressed("ui_accept") and currentChamp.movement_speed == 0:
		if map.getTileID(currentChamp.tile_position)== 2:
				var locales = map.get_spawn_location()
				print(locales)
				currentChamp.position = locales[0]
				currentChamp.tile_position = locales[1]
				print(currentChamp.tile_position)		
		endTurn()


func startTurn():
	currentChamp = turnOrder[currentTurn]
	currentChamp.normalize()
	camera.target_node = currentChamp


func endTurn():
	currentTurn = (currentTurn+1) % turnOrder.size() 
	if currentTurn == 0:
		map.normalize()
	startTurn()

# Called when the node enters the scene tree for the first time.
func _ready():
	GameController.connect("skill_toggled",self.on_skill_toggled)
	GameController.wizard = wizard
	GameController.warrior = warrior
	GameController.rouge = rouge
	turnOrder = [warrior, wizard, rouge]
	turnOrder.shuffle()
	
	

func gameSetup():
	map.generate_chunk()
	mapGenerated = true
	map.updateMapData()
	for champ in turnOrder:
		champ.map = map
		var locales = map.get_spawn_location()
		champ.position = locales[0]
		champ.tile_position = locales[1]
	startTurn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !mapGenerated:
		gameSetup()
	if !skillToggled:
		handleInput()




func on_check_death():
	for champ in turnOrder:
		if !map.checkTileInMap(map.local_to_map(champ.position)):
			champ.queue_free()


func on_skill_toggled(on: bool):
	map.clear_layer(8)
	skillToggled = on
	shownMovedTiles = false	

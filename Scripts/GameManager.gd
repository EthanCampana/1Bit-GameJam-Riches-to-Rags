extends Node

var currentTurn : int
var currentChamp: Champion
var turnOrder = []
var skillToggled : bool
var shownMovedTiles: bool
var mapGenerated : bool	 = false
var moveTiles = []
var moving : bool = false
var gameOver = false

@onready var map : PCGTileMap = $PCGMap
@onready var camera : GameCamera = $GameCamera
@onready var warrior : Champion = $Warrior
@onready var wizard : Champion  = $Wizard
@onready var rouge : Champion = $Rouge
@onready var moveSound = $MoveSound


func showMovement():
	moveTiles = map.updateMovementTiles(currentChamp)
	shownMovedTiles = true

func playerMove(location : Vector2i):
	moving = true
	map.decreaseTileLevel(currentChamp.tile_position)
	currentChamp.tile_position = location
	var tween = get_tree().create_tween()
	moveSound.play()
	tween.tween_property(currentChamp,"position",calculateTileLocation(location),2).set_trans(tween.TRANS_SINE) 
	await tween.finished
	shownMovedTiles = false
	moving = false
	map.clear_layer(8)

	

func calculateTileLocation(tile : Vector2i):
	var endlocation : Vector2				
	var global = map.map_to_local(tile)	
	endlocation.x = global.x
	endlocation.y = global.y - (1 * 128 / 2)
	return endlocation



func handleInput():
	if !shownMovedTiles and currentChamp.movement_speed != 0:
		showMovement()
	if Input.is_action_just_pressed("leftClick"):
		if currentChamp.movement_speed != 0 && map.local_to_map(map.get_global_mouse_position()) in moveTiles && !moving:
			currentChamp.movement_speed -=1
			print(currentChamp.movement_speed)
			playerMove(map.local_to_map(map.get_global_mouse_position()))
		
	if Input.is_action_just_pressed("rightClick"):
		camera.shake()
	if Input.is_action_just_pressed("Skill1"):
		if !currentChamp.skill1.coolDownActivew:
			currentChamp.useSkill(0)
	if Input.is_action_just_pressed("Skill2"):
		if !currentChamp.skill2.coolDownActive:
			currentChamp.useSkill(1)
	if Input.is_action_just_pressed("Skill3"):
		if !currentChamp.skill3.coolDownActive:
			currentChamp.useSkill(2)
	if Input.is_action_just_pressed("ui_accept"):
		if map.getTileID(currentChamp.tile_position)== 2:
				var locales = map.get_spawn_location()
				print(locales)
				currentChamp.position = locales[0]
				currentChamp.tile_position = locales[1]
				print(currentChamp.tile_position)		
		endTurn()



func resetGame():
	currentTurn = 0
	turnOrder = [warrior, wizard, rouge]
	turnOrder.shuffle()
	map.reset()
	gameOver = false
	for champ in turnOrder:
		var locales = map.get_spawn_location()
		champ.position = locales[0]
		champ.tile_position = locales[1]
		champ.visible = true
	gameOver = false
	startTurn()


func gameEnd():
	camera.target_node = currentChamp
	map.clear_layer(8)
	gameOver = true

func startTurn():
	shownMovedTiles = false	
	currentChamp = turnOrder[currentTurn]
	currentChamp.normalize()
	camera.target_node = currentChamp


func endTurn():
	currentTurn = (currentTurn+1) % turnOrder.size() 
	shownMovedTiles = false	
	if turnOrder.size() == 1:
		resetGame()
		return
	if turnOrder.size() == 1:
		gameEnd()
		return
	if currentTurn == 0:
		map.normalize()
		await get_tree().create_timer(3).timeout
	startTurn()

# Called when the node enters the scene tree for the first time.
func _ready():
	GameController.connect("skill_toggled",self.on_skill_toggled)
	GameController.connect("check_death",self.on_check_death)
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
	if !skillToggled and !gameOver:
		handleInput()


func on_check_death():
	for champ in turnOrder:
		var alive = map.checkTileInMap(champ.tile_position) 
		if not alive:
			turnOrder.erase(champ)
			champ.visible = false


func on_skill_toggled(on: bool):
	map.clear_layer(8)
	skillToggled = on
	shownMovedTiles = false	

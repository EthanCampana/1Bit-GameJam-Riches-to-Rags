extends Node

var currentTurn : int
var currentChamp: Champion
var turnOrder = []
var map : TileMap

var camera : GameCamera

var warrior : Champion
var wizard : Champion
var rogue : Champion


var skillToggled : bool

# Need to create a Singleton Game Manageer to inform the GameManager about stuff
# Need to think about sound implementation




func handleInput():
	if Input.is_action_just_pressed("ui_accept"):
		currentChamp.useSkill(0)




func startTurn():
	currentChamp = turnOrder[currentTurn]
	currentChamp.updateCoolDowns()
	camera.target_node = currentChamp


func endTurn():
	currentTurn += 1 % 3
	startTurn()

# Called when the node enters the scene tree for the first time.
func _ready():
	turnOrder = [warrior, wizard, rogue]
	turnOrder.shuffle()
	for champ in turnOrder:
		champ.map = map
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !skillToggled:
		handleInput()
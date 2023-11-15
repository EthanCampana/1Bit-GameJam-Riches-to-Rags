extends Node

var currentTurn : int
var currentChamp: Champion
var turnOrder = []


var warrior : Champion
var wizard : Champion
var rogue : Champion


# Need to create a Singleton Game Manageer to inform the GameManager about stuff
# Need to think about sound implementation





func startTurn():
	currentChamp = turnOrder[currentTurn]

func endTurn():
	currentTurn += 1 % 3
	startTurn()

# Called when the node enters the scene tree for the first time.
func _ready():
	turnOrder = [warrior, wizard, rogue]
	turnOrder.shuffle()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

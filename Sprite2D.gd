extends Sprite2D
var moving = false
var tile_size = 128 
@onready var tiles :TileMap = $"../TileMap"
var GlobalTiles = []
@onready var cam : GameCamera = $"../Camera2D"
@onready var player2: Sprite2D = $"../Carta2-5"
@onready var skill: AttackSkill= $"../AttackSkill"


func _ready():
	GlobalTiles = tiles.get_used_cells(1)	
	print(GlobalTiles)
	position = calculateTileLocation(Vector2i(1,5))		
	player2.position = calculateTileLocation(Vector2i(4,0))			
	



func _unhandled_input(event):
	if event.is_action_pressed("leftClick"):
		var tile = tiles.local_to_map(get_global_mouse_position())
		if tile in GlobalTiles:
			move(tile)
	if event.is_action_pressed("ui_accept"):
		zoomCameraOut()
	if event.is_action_released("ui_accept"):
		zoomCameraIn()
	if event.is_action_pressed("rightClick"):
		if skill.skillBeingUsed:
			var pos = skill.attack(tiles.local_to_map(get_global_mouse_position()))
			move2(pos)
		# cam.target_node = player2
		

func zoomCameraOut():
	var tween = get_tree().create_tween()
	var i 	= tween.tween_property(cam,"zoom",Vector2(0.5,0.5),1).set_trans(tween.TRANS_SINE)
	await tween.finished

func zoomCameraIn():
	var tween = get_tree().create_tween()
	var i 	=tween.tween_property(cam,"zoom",Vector2(1,1),1).set_trans(tween.TRANS_SINE)
	await tween.finished



func calculateTileLocation(locale: Vector2i):
	var endlocation : Vector2				
	var global = tiles.map_to_local(locale)	
	endlocation.x = global.x
	endlocation.y = global.y - (1 * tile_size / 2)
	return endlocation


func move2(tile):
	var tween = get_tree().create_tween()
	tween.tween_property(player2,"position",calculateTileLocation(tile),2).set_trans(tween.TRANS_SINE) 
	await tween.finished

func move(tile):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",calculateTileLocation(tile),2).set_trans(tween.TRANS_SINE) 
	await tween.finished


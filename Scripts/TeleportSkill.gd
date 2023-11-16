extends Skill
class_name TeleportSkill

var cell: Vector2i
var usedSkill : bool = false
@onready var moveSound = $"../../MoveSound"


func select_tile(pos):
	if pos != cell:
		return
	apply(champ) 
	toggled = false
	coolDownActive = true
	coolDownCurrent = coolDownMax
	GameController.emit_signal("skill_toggled", toggled)
	return

# Teleport the player to the random tile 
func apply(target):
	cell = map.get_spawn_location()[1]
	
	target.tile_position = cell
	var tween = get_tree().create_tween()
	moveSound.play()
	# I REUSE THE GAME MANAGER calculateTileLocation METHOD - FIX
	tween.tween_property(target,"position",calculateTileLocation(cell),2).set_trans(tween.TRANS_SINE) 
	await tween.finished


# Highlight the clickable tile black
func tile_selection():
	cell = champ.tile_position
	map.set_cell(8,cell,0,Vector2i(0,1),0)

# THIS IS COPIED FROM GAMEMANAGER
func calculateTileLocation(tile : Vector2i):
	var endlocation : Vector2				
	var global = map.map_to_local(tile)	
	endlocation.x = global.x
	endlocation.y = global.y - (1 * 128 / 2)
	return endlocation

func _process(_delta):
	if toggled:
		if coolDownActive:
			toggled = false
			GameController.emit_signal("skill_toggled", toggled)
		tile_selection()
		if Input.is_action_just_pressed("leftClick"):
			select_tile(map.local_to_map(map.get_global_mouse_position()))
		if Input.is_action_just_pressed("rightClick") and not usedSkill:
			toggled = false
			GameController.emit_signal("skill_toggled", toggled)

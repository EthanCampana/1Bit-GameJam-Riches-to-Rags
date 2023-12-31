extends Skill
class_name JumpSkill

@onready var moveSound = $"../../MoveSound"

var selectedCells= []
var usedSkill : bool = false
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




# Handle if they click the right tile etc
func select_tile(pos):
	usedSkill = true
	if pos not in selectedCells:
		usedSkill = false
		return

	apply(pos)		
	# At the end we want to turn off the toggle
	toggled = false
	usedSkill = false
	coolDownActive = true
	coolDownCurrent = coolDownMax
	GameController.emit_signal("skill_toggled", toggled)
	return



func calculateTileLocation(tile : Vector2i):
	var endlocation : Vector2				
	var global = map.map_to_local(tile)	
	endlocation.x = global.x
	endlocation.y = global.y - (1 * 128 / 2)
	return endlocation


func apply(target):
	champ.tile_position = target
	var tween = get_tree().create_tween()
	moveSound.play()
	tween.tween_property(champ,"position",calculateTileLocation(target),.5).set_trans(tween.TRANS_SINE) 
	await tween.finished
	GameController.emit_signal("check_death")


# This stuff is going to update once we have a firm understanding on how the map works
func tile_selection():
	selectedCells = []
	var surround = map.get_surrounding_cells(champ.tile_position)
	for cell in surround:
		var nextcell = map.get_surrounding_cells(cell)
		selectedCells.append(nextcell[surround.find(cell)])
	for cell in selectedCells:
		var id = map.getTileID(cell)
		var c = GameController.getChampionAtTile(cell)
		if c != null or (id != 0 && id != 2):
			print(id)
			print(c)
			print(cell)
			selectedCells.erase(cell)
	print(selectedCells)
	for cell in selectedCells:
		map.set_cell(8,cell,0,Vector2i(0,1),0)
	


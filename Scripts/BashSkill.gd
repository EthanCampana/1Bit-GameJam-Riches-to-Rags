extends Skill
class_name BashSkill


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
	# Check if the tile they clicked on contains an enem
	var selected : Champion = null
	selected = GameController.getChampionAtTile(pos)
	if selected == null:
		usedSkill = false
		return
	# Apply what ever the skill does to the selected object
	apply(selected)		
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
	var newPos : Vector2i
	var currentPos = champ.tile_position
	var pos = target.tile_position 
	var index = selectedCells.find(target.tile_position)
	newPos = map.get_surrounding_cells(pos)[index]
	target.tile_position = newPos
	var tween = get_tree().create_tween()
	tween.tween_property(target,"position",calculateTileLocation(newPos),.5).set_trans(tween.TRANS_SINE) 
	await tween.finished
	GameController.emit_signal("check_death")



# This stuff is going to update once we have a firm understanding on how the map works
func tile_selection():
	selectedCells = map.get_surrounding_cells(champ.tile_position)
	#SWNE
	print(selectedCells)
	for cell in selectedCells:
		map.set_cell(8,cell,0,Vector2i(0,1),0)


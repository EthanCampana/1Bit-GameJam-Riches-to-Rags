extends Skill
class_name BashSkill


var selectedCells= []

func _process(_delta):
	if toggled:
		tile_selection()
		if Input.is_action_just_pressed("leftClick"):
			select_tile(map.local_to_map(map.get_global_mouse_position()))
		if Input.is_action_just_pressed("rightClick"):
			toggled = false




# Handle if they click the right tile etc
func select_tile(pos):
	if pos not in selectedCells:
		return
	# Check if the tile they clicked on contains an enem
	var data = map.getOccupiedTileData(pos)
	var selected : Champion = null
	match typeof(data):
		TYPE_NIL:
			return
		TYPE_OBJECT:
			selected = data
	# Apply what ever the skill does to the selected object
	apply(selected)		
	# At the end we want to turn off the toggle
	toggled = false
	GameController.emit_signal("skill_toggled", toggled)
	return


func apply(target):
	var newPos : Vector2i
	var currentPos = map.map_to_local(champ.position) 
	var pos = map.map.map_to_local(target.position)
	if currentPos.x == pos.x:
		newPos.x = pos.x-1
	else:
		newPos.x = pos.x 
	newPos.y = (currentPos.y+pos.y)*-1
	map.updateOccupiedTileData(pos,TYPE_NIL )
	var tween = get_tree().create_tween()
	tween.tween_property(target,"position",newPos,2).set_trans(tween.TRANS_SINE) 
	await tween.finished
	map.updateOccupiedTileData(newPos,target)
	GameController.emit_signal("check_death")



# This stuff is going to update once we have a firm understanding on how the map works
func tile_selection():
	var selectedCells = map.get_surrounding_cells(map.local_to_map(champ.position))
	for cell in selectedCells:
		map.set_cell(9,cell,map.get_cell_source_id(1,cell),map.get_cell_atlas_coords(1,cell),0)


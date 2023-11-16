extends Skill
class_name DecaySkill

var selectedCells= []
var usedSkill : bool = false


func select_tile(pos):
	usedSkill = true
	if pos not in selectedCells:
		usedSkill = false
		return
	apply(pos) 
	toggled = false
	coolDownActive = true
	coolDownCurrent = coolDownMax
	GameController.emit_signal("skill_toggled", toggled)
	return

# Decay one tile
func apply(target):
	var layer = map.getTileLayer(target)
	var id = map.getTileID(target)
	map.erase_cell(layer,target)
	map.set_cell(layer-1,target,id,Vector2i(0,1),0)
	map.updateLayerOpacity()



# Highlight the surrounding clickable tiles black
func tile_selection():
	selectedCells = map.get_surrounding_cells(champ.tile_position)
	for cell in selectedCells:
		var id = map.getTileID(cell)
		if id == 99:
			selectedCells.erase(cell)
	for cell in selectedCells:
		map.set_cell(8,cell,0,Vector2i(0,1),0)

func _process(_delta):
	if toggled:
		if coolDownActive:
			toggled = false
			GameController.emit_signal("skill_toggled", toggled)
		tile_selection()
		if Input.is_action_just_pressed("leftClick"):
			select_tile(map.local_to_map(map.get_global_mouse_position()))
		if Input.is_action_just_pressed("ui_accept") and not usedSkill:
			toggled = false
			GameController.emit_signal("skill_toggled", toggled)

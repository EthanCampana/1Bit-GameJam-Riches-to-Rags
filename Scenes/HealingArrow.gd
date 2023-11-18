extends Skill
class_name HealingArrow


var cell: Vector2i
var usedSkill : bool = false

func select_tile(pos):
	if pos != cell:
		return
	apply(champ) 
	toggled = false
	coolDownActive = true
	coolDownCurrent = coolDownMax
	GameController.emit_signal("skill_toggled", toggled)
	return


func apply(target):
	map.increaseTileLevel(target)

func tile_selection():
	cell = champ.tile_position
	map.set_cell(8,cell,0,Vector2i(0,1),0)


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

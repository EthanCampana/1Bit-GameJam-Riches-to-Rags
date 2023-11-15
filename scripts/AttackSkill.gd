extends Node
class_name AttackSkill


var skillBeingUsed = true 
var curHighlet = null
var  map : TileMap
func _ready():
	map = $"../TileMap"

func _process(_delta):
	if skillBeingUsed:
		var tile = map.local_to_map(map.get_global_mouse_position())
		if curHighlet == null:
			curHighlet = tile
			map.set_cell(2,tile,map.get_cell_source_id(1,tile),map.get_cell_atlas_coords(1,tile),0)
		elif tile != curHighlet:
			map.erase_cell(2,curHighlet)
			curHighlet = tile
			map.set_cell(2,tile,map.get_cell_source_id(1,tile),map.get_cell_atlas_coords(1,tile),0)
		

func attack(pos):
	var newPos : Vector2i
	var currentPos = Vector2i(3,-1)
	if currentPos.x == pos.x:
		newPos.x = pos.x-1
	else:
		newPos.x = pos.x 
	newPos.y = (currentPos.y+pos.y)*-1
	print(newPos)
	return newPos




func useSkill():
	skillBeingUsed = true
   

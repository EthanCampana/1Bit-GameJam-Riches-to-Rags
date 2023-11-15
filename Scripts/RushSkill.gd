extends Skill
class_name RushSkill


var cell: Vector2i


func _process(_delta):
    if toggled:
        tile_selection()
        if Input.is_action_just_pressed("leftClick"):
            select_tile(map.local_to_map(map.get_global_mouse_position()))
        if Input.is_action_just_pressed("rightClick"):
            toggled = false

func select_tile(pos):
    if pos != cell:
        return
    apply(champ) 
    toggled = false
    GameController.emit_signal("skill_toggled", toggled)
    return


func apply(target):
    target.movement_speed *=2

func tile_selection():
    cell = map.local_to_map(champ.position)
    map.set_cell(9,cell,map.get_cell_source_id(1,cell),map.get_cell_atlas_coords(1,cell),0)
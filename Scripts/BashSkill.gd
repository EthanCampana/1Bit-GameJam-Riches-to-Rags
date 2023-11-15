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

    # At the end we want to turn off the toggle
    # We will probably also send a signal here to the game controller with some inf
    toggled = false
    return



# This stuff is going to update once we have a firm understanding on how the map works
func tile_selection():
    var selectedCells = map.get_surrounding_cells(map.local_to_map(champ.position))
    for cell in selectedCells:
        map.set_cell(2,cell,map.get_cell_source_id(1,cell),map.get_cell_atlas_coords(1,cell),0)


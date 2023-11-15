extends Node
class_name Skill

var coolDownMax: int
var coolDownCurrent: int    
var coolDownActive : bool = false
var map : TileMap
var champ : Champion
var toggled : bool = false  


# Toggles the skill on and off. Used to determine whether the player should be able to move or select a tile for a skill
func toggle(champ: Champion, map: TileMap):
    map = map
    champ = champ
    toggled = true  

# This function defines the skills radius / selected tiles. How far can the skill reach? What tiles can it affect?
# All of that goes here
func tile_selection():
    pass

# This does the spells effect and handles all the tile checks.
# Can a spell be casted on this tile? etc
func select_tile(pos):
    pass
extends Node




var warrior : Champion 
var wizard : Champion  
var rouge : Champion

signal skill_toggled(on : bool)
signal check_death()



func getChampionAtTile(tile):
	if warrior.tile_position == tile:
		return warrior
	if wizard.tile_position == tile:
		return wizard
	if rouge.tile_position == tile:
		return rouge

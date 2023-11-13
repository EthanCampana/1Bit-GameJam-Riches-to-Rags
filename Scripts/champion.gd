extends Node2D
class_name Champion

@export var movement_speed_max : int
var movement_speed : int
@export var skill1 : Skill
@export var skill2 : Skill
@export var skill3 : Skill
@export var map : PCGTileMap
@export var sprite : Sprite2D
var tile_position : Vector2i
var skills = []


func normalize():
	# updateCoolDowns()
	movement_speed = movement_speed_max


func updateCoolDowns():
	for skill in skills:
		if skill.coolDownActive:
			skill.coolDown -= 1
			if skill.coolDown <= 0:
				skill.coolDownActive = false
				skill.coolDown = skill.coolDownMax




func useSkill(skillNum):
	skills[skillNum].toggle(self,map)

# Called when the node enters the scene tree for the first time.
func _ready():
	skills = [skill1, skill2, skill3]	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

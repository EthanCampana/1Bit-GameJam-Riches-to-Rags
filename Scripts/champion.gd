extends Node2D
class_name Champion

@export var texture : Texture 
@export var movement_speed : int
@export var skill1 : Skill
@export var skill2 : Skill
@export var skill3 : Skill
@export var map : TileMap
var skills = [skill1, skill2, skill3]	


@onready var sprite : Sprite2D = $"Sprite2D"



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
	sprite.texture = texture	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

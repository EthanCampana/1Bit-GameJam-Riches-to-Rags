extends Node2D
class_name Champion

@export var texture : Texture 
@export var movement_speed : int
@export var skill1 : Skill
@export var skill2 : Skill
@export var skill3 : Skill
@export var map : TileMap


@onready var sprite : Sprite2D = $"Sprite2D"



func useSkillOne():
	skill1.toggle(self,map)

func useSkillTwo():
	skill2.toggle(self,map)
	
func useSkillThree():
	skill3.toggle(self,map)

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = texture	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

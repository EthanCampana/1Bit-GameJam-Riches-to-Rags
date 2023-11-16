extends Node2D

var nextWorld

@onready var currentWorld = load("res://Scenes/TitleScreen.tscn")
@onready var anim = $AnimationPlayer


#func _ready() -> void:
	#currentWorld.connect("worldChanged", self, "handleWorldChanged")
	

func handleWorldChanged(currentWorldName: String):
	var nextWorldName: String
	
	match currentWorldName:
		"TitleScreen":
			nextWorldName = "main_scene"
		_:
			return
	
	nextWorld = load("res://" + nextWorldName + "tscn").instance()
	nextWorld.z_index = -1
	add_child(nextWorld)
	anim.play("fadeIn")
	nextWorld.connect("worldChanged", self, "handleWorldChanged")


func _on_animation_player_animation_finished(animName):
	match animName:
		"fadeIn":
			currentWorld.queue_free()
			currentWorld = nextWorld
			currentWorld.z_index = 0
			nextWorld = null
			anim.play("fadeOut")
			
